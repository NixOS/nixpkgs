{
  lib,
  stdenv,
  buildPackages,
  pkgsBuildBuild,
  callPackage,
  runCommand,
  symlinkJoin,
  fetchFromGitHub,
  fetchurl,
  installShellFiles,
  cmake,
  ninja,
  go,
  perl,
  gitMinimal,
  nasm,
  rustc,
  cargo,
  rustPlatform,
  llvmPackages,
  icu,
  sqlite,
  cctools,
  darwin,
  rcodesign,
  bun-webkit ? callPackage ./webkit/package.nix {
    inherit llvmPackages;
  },
}:

let
  sources = lib.importJSON ./sources.json;
  inherit (sources)
    bootstrapAssets
    nodeModulesHashes
    revision
    version
    ;

  inherit (stdenv) buildPlatform hostPlatform;
  inherit (hostPlatform) isDarwin isLinux isMusl;
  isCross = buildPlatform != hostPlatform;
  bootstrapPlatformKey = buildPlatform.system + lib.optionalString buildPlatform.isMusl "-musl";
  hostClang = pkgsBuildBuild.llvmPackages.clang;

  # Bun checks the LLVM major in scripts/build/tools.ts. Review llvmPackages when
  # it changes. The override accepts one bin directory, so join the LLVM outputs.
  llvmToolchain = symlinkJoin {
    name = "bun-llvm-toolchain";
    paths = [
      llvmPackages.clang
      llvmPackages.llvm
      llvmPackages.lld
    ];
  };

  bootstrapAsset =
    bootstrapAssets.${bootstrapPlatformKey}
      or (throw "Unsupported Bun bootstrap platform: ${bootstrapPlatformKey}");

  # Node modules contain build-time tools such as esbuild, so select them for
  # the platform that runs the build. Linux installs include both libc variants.
  nodeModulesHash =
    nodeModulesHashes.${buildPlatform.system}
      or (throw "Unsupported Bun node_modules platform: ${buildPlatform.system}");

  # macOS libicucore lacks _ubrk_clone. Use Nix ICU until Bun stops needing it.
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

  bootstrap = buildPackages.stdenvNoCC.mkDerivation {
    pname = "bun-bootstrap";
    inherit version;

    src = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/${bootstrapAsset.name}.zip";
      inherit (bootstrapAsset) hash;
    };
    sourceRoot = bootstrapAsset.name;

    strictDeps = true;
    nativeBuildInputs = [
      buildPackages.unzip
    ]
    ++ lib.optional buildPlatform.isLinux buildPackages.patchelf
    ++ lib.optionals buildPlatform.isDarwin [
      buildPackages.cctools
      buildPackages.rcodesign
    ];
    buildInputs = lib.optional buildPlatform.isDarwin buildPackages.darwin.ICU;

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 bun "$out/bin/bun"

      runHook postInstall
    '';

    # The bootstrap runs on buildPlatform, so use buildPackages for its fixups.
    postFixup =
      lib.optionalString buildPlatform.isLinux ''
        if patchelf --print-interpreter "$out/bin/bun" >/dev/null 2>&1; then
          patchelf \
            --set-interpreter '${buildPackages.stdenv.cc.bintools.dynamicLinker}' \
            "$out/bin/bun"
        fi
      ''
      + lib.optionalString buildPlatform.isDarwin ''
        '${lib.getExe' buildPackages.cctools "${buildPackages.cctools.targetPrefix}install_name_tool"}' \
          "$out/bin/bun" \
          -change /usr/lib/libicucore.A.dylib \
          '${lib.getLib buildPackages.darwin.ICU}/lib/libicucore.A.dylib'
        '${lib.getExe buildPackages.rcodesign}' sign \
          --code-signature-flags linker-signed \
          "$out/bin/bun"
      '';
  };

  # Keep these directories in sync with NODE_MODULE_DIRS in update.py and
  # emitPackageInstall() calls in upstream codegen.ts.
  nodeModules = buildPackages.stdenvNoCC.mkDerivation {
    pname = "bun-node-modules";
    inherit version src;

    strictDeps = true;
    nativeBuildInputs = [
      bootstrap
      buildPackages.cacert
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

  # Bun overwrites .cargo/config.toml. Put the vendor config in CARGO_HOME
  # instead of using cargoSetupHook.
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
    # Review after upstream changes dependency installs, Linux targets, Rust
    # release flags, or host tool discovery.
    ./support-nix-build-environment.patch

    # Keep this bridge in sync with build() and provides() in webkit.ts.
    ./use-nix-webkit.patch
  ];

  disallowedReferences = [
    bootstrap
    bun-webkit
  ];

  depsBuildBuild = lib.optionals (isLinux && isCross) [
    pkgsBuildBuild.stdenv.cc
    hostClang
  ];

  nativeBuildInputs = [
    bootstrap
    installShellFiles
    cmake
    ninja
    go
    perl
    gitMinimal
    nasm
    llvmPackages.clang
    llvmPackages.llvm
    llvmPackages.lld
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
    bun-webkit
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
  # compiler wrapper sets the interpreter and RPATH.
  dontPatchELF = isLinux;

  # Bun controls _FORTIFY_SOURCE in its own build flags.
  hardeningDisable = [ "fortify" ];

  env = {
    GIT_SHA = revision;
    NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
      # Nix LLVM 21 has no zstd debug compression support.
      "-gz=zlib"
      # Keep the build-only WebKit output out of the Bun runtime closure.
      "-ffile-prefix-map=${bun-webkit}=build/release/deps/webkit"
    ];
    NIX_LDFLAGS = lib.concatStringsSep " " (
      lib.optionals isLinux [
        "--disable-new-dtags"
        "-rpath"
        (lib.makeLibraryPath [
          stdenv.cc.cc
          icu
        ])
      ]
      # Keep __BUN last so standalone executables can grow their module graph.
      # https://github.com/oven-sh/bun/issues/40107
      ++ lib.optionals isDarwin [ "-rename_segment __DATA_DIRTY __DATA" ]
    );
    BUN_WEBKIT_DIR = bun-webkit;
    BUN_NIX_BUILD_ABI = lib.optionalString buildPlatform.isLinux (
      if buildPlatform.isMusl then "musl" else "gnu"
    );
    BUN_NIX_CROSS = lib.optionalString (isLinux && isCross) "1";
    BUN_NIX_HOST_CC = lib.optionalString isCross "${hostClang}/bin/clang";
    BUN_NIX_HOST_CXX = lib.optionalString isCross "${hostClang}/bin/clang++";

    # Upstream uses nightly-only Rust compiler options.
    RUSTC_BOOTSTRAP = 1;
    BUN_BUILD_PREFETCH_DIR = buildPrefetch;
    BUN_TOOLCHAIN_LLVM = llvmToolchain;
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
      --os=${hostPlatform.parsed.kernel.name}
      --arch=${if hostPlatform.isAarch64 then "aarch64" else "x64"}
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

  doInstallCheck = buildPlatform.canExecute hostPlatform;
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

  passthru = {
    updateScript = ./update.py;
    webkit = bun-webkit;
  };

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
