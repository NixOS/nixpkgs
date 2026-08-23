{
  lib,
  stdenv,
  stdenvNoCC,
  runCommand,
  fetchFromGitHub,
  fetchgit,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  unzip,
  cacert,
  cmake,
  ninja,
  pkg-config,
  bison,
  gawk,
  gperf,
  python3,
  go,
  libtool,
  automake,
  autoconf,
  ruby,
  perl,
  git,
  nasm,
  which,
  rustc,
  cargo,
  rustPlatform,
  llvmPackages_21,
  openssl,
  icu,
  libxml2,
  sqlite,
  cctools,
  darwin,
  rcodesign,
}:

let
  sources = lib.importJSON ./sources.json;
  inherit (sources)
    bootstrapAssets
    nodeModulesHashes
    revision
    version
    ;

  isLinux = stdenv.hostPlatform.isLinux;
  isDarwin = stdenv.hostPlatform.isDarwin;
  isMusl = stdenv.hostPlatform.isMusl;
  platformKey = stdenv.hostPlatform.system + lib.optionalString isMusl "-musl";
  webkitSource = import ./webkit.nix {
    inherit fetchgit;
    inherit (sources) webkit;
  };

  bootstrapAsset =
    bootstrapAssets.${platformKey} or (throw "Unsupported Bun bootstrap platform: ${platformKey}");

  # bun install selects native packages such as esbuild for the host platform.
  # Linux installs keep both glibc and musl variants, so the hash only differs
  # by system and CPU architecture.
  nodeModulesHash =
    nodeModulesHashes.${stdenv.hostPlatform.system}
      or (throw "Unsupported Bun node_modules platform: ${stdenv.hostPlatform.system}");

  fixDarwinBinary =
    binary:
    lib.optionalString isDarwin ''
      '${lib.getExe' cctools "${cctools.targetPrefix}install_name_tool"}' "${binary}" \
        -change /usr/lib/libicucore.A.dylib '${lib.getLib darwin.ICU}/lib/libicucore.A.dylib'
      '${lib.getExe rcodesign}' sign --code-signature-flags linker-signed "${binary}"
    '';

  src = fetchFromGitHub {
    owner = "oven-sh";
    repo = "bun";
    rev = revision;
    hash = sources.sourceHash;
  };

  # Bun's cache consumes the original archives, not unpacked GitHub sources.
  downloads = map (
    download:
    fetchurl {
      inherit (download) url hash;
      name = "bun-${download.name}.tar.gz";
    }
  ) sources.downloads;

  # Bun stores prefetched archives under the first 32 characters of SHA-256(url).
  cacheKey = download: builtins.substring 0 32 (builtins.hashString "sha256" download.url);

  bootstrap = stdenvNoCC.mkDerivation {
    pname = "bun-bootstrap";
    inherit version;

    src = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/${bootstrapAsset.name}.zip";
      inherit (bootstrapAsset) hash;
    };
    sourceRoot = bootstrapAsset.name;

    strictDeps = true;
    nativeBuildInputs = [
      unzip
    ]
    ++ lib.optionals isLinux [ autoPatchelfHook ]
    ++ lib.optionals isDarwin [
      cctools
      rcodesign
    ];
    buildInputs =
      lib.optionals isLinux [
        openssl
        stdenv.cc.cc.lib
      ]
      ++ lib.optionals isDarwin [ darwin.ICU ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 bun "$out/bin/bun"

      runHook postInstall
    '';

    postFixup = fixDarwinBinary "$out/bin/bun";
  };

  nodeModules = stdenvNoCC.mkDerivation {
    pname = "bun-node-modules";
    inherit version src;

    strictDeps = true;
    nativeBuildInputs = [
      bootstrap
      cacert
    ];
    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export HOME="$TMPDIR/home"
      export BUN_INSTALL_CACHE_DIR="$TMPDIR/bun-cache"
      mkdir -p "$HOME" "$BUN_INSTALL_CACHE_DIR"

      for packageDir in . packages/bun-error src/node-fallbacks; do
        (cd "$packageDir" && bun install --frozen-lockfile)
      done

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -R --parents \
        node_modules \
        packages/bun-error/node_modules \
        src/node-fallbacks/node_modules \
        "$out"

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = nodeModulesHash;
  };

  buildPrefetch = runCommand "bun-build-prefetch-${version}" { } ''
    mkdir -p "$out/by-url"
    ${lib.concatMapStringsSep "\n" (download: ''
      ln -s ${download} "$out/by-url/${cacheKey download}"
    '') downloads}
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = "bun-cargo-deps";
    inherit version src;
    hash = sources.cargoHash;
  };
in
stdenv.mkDerivation {
  pname = "bun-unwrapped";
  inherit version src;

  __structuredAttrs = true;

  patches = [
    # Keep dependency installation offline and expose Nix-specific ABI,
    # toolchain, and runtime search path settings to Bun's build script.
    ./support-nix-build-environment.patch

    # Build only the WebKit libraries linked into Bun from the pinned source.
    ./build-webkit-from-source.patch

    # Keep the standalone graph segment last when linking natively on Darwin.
    # https://github.com/oven-sh/bun/issues/40107
    ./fix-darwin-standalone-segment-order.patch
  ];

  # Recheck this pin when Bun changes its required LLVM version.
  nativeBuildInputs = [
    bootstrap
    installShellFiles
    cmake
    ninja
    pkg-config
    bison
    gawk
    gperf
    python3
    go
    libtool
    automake
    autoconf
    ruby
    perl
    git
    unzip
    nasm
    which
    llvmPackages_21.clang
    llvmPackages_21.llvm
    llvmPackages_21.lld
    rustc
    cargo
  ]
  ++ lib.optionals isDarwin [
    cctools
    darwin.bootstrap_cmds
    rcodesign
  ];

  # nixpkgs removes SQLite headers from apple-sdk. Bun uses the header while
  # compiling, then loads macOS libsqlite3.dylib at runtime.
  buildInputs = [
    libxml2
  ]
  ++ lib.optionals isLinux [ icu ]
  ++ lib.optionals isDarwin [
    darwin.ICU
    (lib.getDev sqlite)
  ];

  # Executables produced by `bun build --compile` link against ICU. Propagate
  # its library output so downstream fixup hooks can resolve that dependency.
  propagatedBuildInputs = lib.optionals isLinux [ (lib.getLib icu) ];

  strictDeps = true;
  dontConfigure = true;

  # patchelf breaks executables produced by `bun build --compile`. The Nix
  # compiler wrapper sets the interpreter, and Bun's build sets the RPATH.
  dontPatchELF = isLinux;

  # Bun controls _FORTIFY_SOURCE in its own build flags.
  hardeningDisable = [ "fortify" ];

  env = {
    GIT_SHA = revision;
    BUN_NIX_RPATH = lib.optionalString isLinux (
      lib.makeLibraryPath [
        stdenv.cc.cc
        icu
      ]
    );
    BUN_WEBKIT_PATH = webkitSource;
    BUN_NIX_ABI = lib.optionalString isLinux (if isMusl then "musl" else "gnu");
    BUN_NIX_GPERF = lib.optionalString isDarwin (lib.getExe gperf);
    BUN_NIX_MIG = lib.optionalString isDarwin (lib.getExe' darwin.bootstrap_cmds "mig");

    # Upstream uses nightly-only Rust compiler options.
    RUSTC_BOOTSTRAP = 1;
    BUN_BUILD_PREFETCH_DIR = buildPrefetch;
    CC = lib.getExe llvmPackages_21.clang;
    CXX = lib.getExe' llvmPackages_21.clang "clang++";
    AR = lib.getExe' llvmPackages_21.llvm "llvm-ar";
    RANLIB = lib.getExe' llvmPackages_21.llvm "llvm-ranlib";
  };

  preBuild = ''
    cp -R "${nodeModules}/node_modules" node_modules
    cp -R "${nodeModules}/packages/bun-error/node_modules" packages/bun-error/node_modules
    cp -R "${nodeModules}/src/node-fallbacks/node_modules" src/node-fallbacks/node_modules
    chmod -R u+w \
      node_modules \
      packages/bun-error/node_modules \
      src/node-fallbacks/node_modules

    export HOME="$TMPDIR/home"
    export BUN_INSTALL="$TMPDIR/bun-install"
    export CARGO_HOME="$TMPDIR/cargo-home"
    export RUSTUP_HOME="$TMPDIR/rustup-home"
    mkdir -p "$HOME" "$BUN_INSTALL" "$CARGO_HOME" "$RUSTUP_HOME"

    substitute ${cargoDeps}/.cargo/config.toml "$CARGO_HOME/config.toml" \
      --replace-fail '@vendor@' '${cargoDeps}'
    cat >> "$CARGO_HOME/config.toml" <<EOF

    [net]
    offline = true
    EOF
  '';

  buildPhase = ''
    runHook preBuild

    buildArgs=(
      --profile=release
      --canary=off
      --webkit=local
      --static-libatomic=off
      --cache-dir="$TMPDIR/bun-build-cache"
      -j"$NIX_BUILD_CORES"
    )
    ${lib.optionalString isLinux ''
      buildArgs+=(--abi=${if isMusl then "musl" else "gnu"})
    ''}
    bun scripts/build.ts "''${buildArgs[@]}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 build/release/bun "$out/bin/bun"
    ln -s bun "$out/bin/bunx"
    installShellCompletion --cmd bun \
      --bash completions/bun.bash \
      --fish completions/bun.fish \
      --zsh completions/bun.zsh

    runHook postInstall
  '';

  postFixup = fixDarwinBinary "$out/bin/bun";

  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;
  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/bun" --version | grep -Fx '${version}'

    # JavaScriptCore and ICU. The upstream libc probe hardcodes /usr/lib/libc.so
    # on musl, which does not exist in Nix; keep the other 32 Intl tests.
    ${lib.optionalString isMusl ''
      CI=1 "$out/bin/bun" test test/js/web/intl/intl.test.ts \
        --test-name-pattern='^(?!.*default locale under C\.UTF-8).*$'
    ''}
    ${lib.optionalString (!isMusl) ''
      CI=1 "$out/bin/bun" test test/js/web/intl/intl.test.ts
    ''}

    # JIT, WebAssembly, SQLite and compiled executables.
    CI=1 "$out/bin/bun" test \
      test/regression/issue/32793.test.ts \
      test/regression/issue/14709.test.ts \
      test/js/web/fetch/wasm-streaming.test.ts \
      test/bundler/bun-build-compile-wasm.test.ts

    # Runtime, TypeScript and module loading.
    CI=1 "$out/bin/bun" test test/cli/run/run-eval.test.ts

    # Offline workspace installation.
    CI=1 "$out/bin/bun" test test/regression/issue/3192.test.ts

    # Bundling with code splitting.
    CI=1 "$out/bin/bun" test test/regression/issue/5344.test.ts

    # Native compilation and signal handling through bun:ffi.
    ${lib.optionalString isLinux ''
      CI=1 \
        C_INCLUDE_PATH="${lib.getDev stdenv.cc.libc}/include" \
        LIBRARY_PATH="${lib.getLib stdenv.cc.libc}/lib" \
        "$out/bin/bun" test test/regression/issue/20144/20144.test.ts
    ''}
    ${lib.optionalString isDarwin ''
      CI=1 "$out/bin/bun" test test/regression/issue/20144/20144.test.ts
    ''}

    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.py;

  meta = {
    homepage = "https://bun.sh";
    changelog = "https://bun.sh/blog/bun-v${version}";
    description = "Incredibly fast JavaScript runtime, bundler, transpiler and package manager – all in one";
    longDescription = ''
      All in one fast & easy-to-use tool. Instead of 1,000 node_modules for development, you only need bun.
    '';
    license = with lib.licenses; [
      mit # Bun core
      lgpl21Only # JavaScriptCore and WebKit
    ];
    maintainers = [
      lib.maintainers.DAlperin
      lib.maintainers.jk
      lib.maintainers.thilobillerbeck
      lib.maintainers.cdmistman
      lib.maintainers.diogomdp
      lib.maintainers._9bingyin
    ];
    mainProgram = "bun";
    platforms = builtins.attrNames nodeModulesHashes;
  };
}
