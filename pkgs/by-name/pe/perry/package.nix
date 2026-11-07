{
  lib,
  stdenv,
  rustPlatform,
  runCommand,
  fetchFromGitHub,
  llvmPackages_22,
  libffi,
  libxml2,
  zlib,
  cmake,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "perry";
  version = "0.5.1664";

  src = fetchFromGitHub {
    owner = "PerryTS";
    repo = "perry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hZw7ht6qbvU6KxYLmAxIRibmWNffDyBRDCC5o3/27s0=";
  };

  cargoHash = "sha256-Pa0G2TKrWDIgYUNPPkU3RAUbcQRI6LTsXEjk03mMY+g=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    llvmPackages_22.clang # perry-runtime's build.rs compiles perry_trap.ll
    cmake
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    llvmPackages_22.llvm
    libffi
    libxml2
    zlib
    openssl
  ];

  env = {
    LLVM_SYS_221_PREFIX = "${lib.getDev llvmPackages_22.llvm}";
    # Perry pins a nightly toolchain (-Z use-sync-unwind, float_algebraic)
    RUSTC_BOOTSTRAP = 1;
    OPENSSL_NO_VENDOR = 1;
  };

  postBuild = ''
    patchShebangs scripts/gc_call_effects/sidecars.sh

    scripts/gc_call_effects/sidecars.sh \
      target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release
  '';

  # perry links user programs against these archives at compile time, and
  # shells out to clang (assembler for the statepoint rewrite) and cc (linker)
  postInstall = ''
    install -Dm644 target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release/libperry_*.a* \
      -t $out/lib

    wrapProgram $out/bin/perry \
      --prefix PATH : ${
        lib.makeBinPath [
          stdenv.cc
          llvmPackages_22.clang
        ]
      } \
      --suffix LIBRARY_PATH : ${lib.makeLibraryPath [ openssl ]} \
      --set-default PERRY_LLVM_CLANG ${lib.getExe llvmPackages_22.clang} \
      --set-default PERRY_RUNTIME_DIR $out/lib \
      --set-default PERRY_NO_TELEMETRY 1
  '';

  # strip would rewrite the archives and invalidate their .gc-effects sidecars
  stripExclude = [ "*.a" ];

  # upstream runtime tests must run single-threaded and the gap suite needs
  # node 26.12.1 as an oracle, so the test suite is not run here.
  doCheck = false;

  __structuredAttrs = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      # Compiles and runs a program that throws and catches an exception.
      # Perry's exception handling relies on the unwind tables requested by
      # upstream's .cargo/config.toml, so this fails if the build loses them
      # (a plain hello world would not notice).
      hello =
        runCommand "perry-hello-test"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            cat > hello.ts <<'EOF'
            try {
              throw new Error("boom");
            } catch (e) {
              console.log("caught:", (e as Error).message);
            }
            EOF

            perry compile hello.ts -o hello
            [ "$(./hello)" = "caught: boom" ]

            touch $out
          '';

      # Uses Node built-in modules that perry resolves to the separately
      # installed libperry_ext_*.a archives. Checks that perry finds them via
      # PERRY_RUNTIME_DIR and that linking against OpenSSL works.
      node-modules =
        runCommand "perry-node-modules-test"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            cat > mods.ts <<'EOF'
            import { createHash } from "node:crypto";
            import { gunzipSync, gzipSync } from "node:zlib";

            console.log(createHash("sha256").update("perry").digest("hex"));
            console.log(gunzipSync(gzipSync("hello")).toString());
            EOF

            perry compile mods.ts -o mods
            ./mods > output

            # sha256("perry")
            grep -qx f7eab37c35b6adc939351d80469308c73c8ac17e7fa9a2b0ac631c8f3f52446a output
            grep -qx hello output

            touch $out
          '';
    };
  };

  meta = {
    description = "Compiles TypeScript/JavaScript directly to executables using SWC and LLVM.";
    homepage = "https://www.perryts.com";
    downloadPage = "https://github.com/PerryTS/perry/releases";
    changelog = "https://github.com/PerryTS/perry/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirdukkkkk ];
    mainProgram = "perry";
    platforms = lib.platforms.linux;
  };
})
