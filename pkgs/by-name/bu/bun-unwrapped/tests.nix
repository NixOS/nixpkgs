{
  lib,
  stdenv,
  runCommand,
  darwin,
  cmake,
  ninja,
  nasm,
  perl,
  gitMinimal,
  llvmPackages,
  bootstrap,
  rustcWithLibSrc,
  cargo,
  bun-unwrapped,
}:

let
  inherit (bun-unwrapped) version src;
  inherit (stdenv.hostPlatform) isDarwin isLinux;

  rustTestConfig = builtins.toFile "bun-rust-unit-configure.json" (
    builtins.toJSON {
      profile = "release";
      overrides = {
        os = stdenv.hostPlatform.parsed.kernel.name;
        arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x64";
        canary = false;
        webkit = "prebuilt";
        staticLibatomic = false;
      }
      // lib.optionalAttrs isLinux {
        abi = if stdenv.hostPlatform.isMusl then "musl" else "gnu";
      };
    }
  );
in
{
  rust-unit = stdenv.mkDerivation {
    pname = "bun-rust-unit-tests";
    inherit version src;
    inherit (bun-unwrapped) patches preBuild;

    __structuredAttrs = true;
    strictDeps = true;
    nativeBuildInputs = [
      bootstrap
      rustcWithLibSrc
      cargo
      cmake
      ninja
      perl
      gitMinimal
      llvmPackages.clang
      llvmPackages.llvm
      llvmPackages.lld
    ]
    ++ lib.optional stdenv.hostPlatform.isx86_64 nasm;
    env = {
      inherit (bun-unwrapped.env)
        GIT_SHA
        RUSTC_BOOTSTRAP
        BUN_BUILD_PREFETCH_DIR
        BUN_NIX_BUILD_ABI
        BUN_TOOLCHAIN_LLVM
        BUN_TOOLCHAIN_RUST
        BUN_TOOLCHAIN_CARGO
        ;
    };

    dontConfigure = true;
    buildPhase = ''
      runHook preBuild

      # Replay configure without downloading upstream's optional Ninja fork.
      bun scripts/build.ts --config-file=${rustTestConfig}
      ninja -C build/release -j"$NIX_BUILD_CORES" clone-lolhtml clone-rust-argon2

      runHook postBuild
    '';

    doCheck = true;
    checkPhase = ''
      runHook preCheck

      export BUN_CODEGEN_DIR="$PWD/build/release/codegen"
      # Pool tests share drop counters with thread-local cleanup.
      cargo test --offline --locked -p bun_collections --lib -j"$NIX_BUILD_CORES" -- --test-threads=1

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      runHook postInstall
    '';
  };

  offline-runtime =
    runCommand "bun-offline-runtime-tests-${version}"
      {
        nativeBuildInputs = [ bun-unwrapped ] ++ lib.optional isDarwin darwin.DarwinTools;
      }
      ''
        cp -R ${src} source
        chmod -R u+w source
        cd source

        export HOME="$TMPDIR/home"
        export CI=1
        export BUN_ENABLE_CRASH_REPORTING=0
        mkdir -p "$HOME"

        # Nix's 64 MiB stack limit exceeds Bun's Mach-O stack. Match a macOS shell.
        ${lib.optionalString isDarwin ''
          ulimit -s 8192
        ''}

        # These upstream tests use built-in modules and checked-in fixtures only.
        bun test --expose-internals --isolate --bail --only-failures \
          test/js/bun/jsonl \
          test/js/bun/jsonc \
          test/js/bun/json5 \
          test/js/bun/toml \
          test/js/bun/yaml \
          test/js/bun/ini \
          test/js/bun/sqlite \
          test/js/bun/util/hash.test.js \
          test/js/bun/util/bun-cryptohasher.test.ts \
          test/js/node/buffer-utf16.test.ts \
          test/js/web/fetch/blob-cow.test.ts \
          test/js/web/url/url-wpt-constructor.test.ts

        touch "$out"
      '';
}
