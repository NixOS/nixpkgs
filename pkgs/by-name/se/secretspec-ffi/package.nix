{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  cargo-c,
  nix-update-script,
  pkg-config,
  runCommandCC,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec-ffi";
  version = "0.19.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "secretspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u6zfPsyLoktLQTE8OEDhK0GtiogOw/3ML4zpDVhSrX0=";
  };

  cargoHash = "sha256-ogeNTp94FJv7p+eZgrLUK1i63VCHiqHd7BsP+jDMHVc=";

  nativeBuildInputs = [ cargo-c ];

  # Keep the static archive intact while removing non-exported symbols from the shared library.
  stripDebugFlags = if stdenv.hostPlatform.isDarwin then [ "-x" ] else [ "--strip-unneeded" ];
  stripExclude = [ "lib/libsecretspec_ffi.a" ];

  buildPhase = ''
    runHook preBuild
    ${buildPackages.rust.envVars.setEnv} cargo cbuild -p secretspec-ffi -j $NIX_BUILD_CORES \
      --profile dist --frozen --prefix=${placeholder "out"} \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${buildPackages.rust.envVars.setEnv} cargo cinstall -p secretspec-ffi -j $NIX_BUILD_CORES \
      --profile dist --frozen --prefix=${placeholder "out"} \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ${buildPackages.rust.envVars.setEnv} cargo ctest -p secretspec-ffi -j $NIX_BUILD_CORES \
      --profile dist --frozen --prefix=${placeholder "out"} \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postCheck
  '';

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        versionCheck = true;
      };
      smoke =
        runCommandCC "${finalAttrs.pname}-smoke-test"
          {
            nativeBuildInputs = [ pkg-config ];
            buildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            $CC ${finalAttrs.src}/secretspec-ffi/tests/smoke.c \
              $(pkg-config --cflags --libs secretspec_ffi) \
              -o smoke
            ./smoke
            touch $out
          '';
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "C ABI for resolving secrets through SecretSpec";
    homepage = "https://secretspec.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
    pkgConfigModules = [ "secretspec_ffi" ];
  };
})
