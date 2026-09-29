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
  pname = "libsecretspec";
  version = "0.21.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "secretspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-12jIhLZhtyQwkt2vKHqjGOuKSwwevcxzp8Ii02RTMLY=";
  };

  cargoHash = "sha256-yqBAhnHBwKbSyH8sEDo6y0xGUdKJgHd3Gsr1sTS/bRc=";

  nativeBuildInputs = [ cargo-c ];

  # Keep the static archive intact while removing non-exported symbols from the shared library.
  stripDebugFlags = if stdenv.hostPlatform.isDarwin then [ "-x" ] else [ "--strip-unneeded" ];
  stripExclude = [ "lib/libsecretspec.a" ];

  buildPhase = ''
    runHook preBuild
    ${buildPackages.rust.envVars.setEnv} cargo cbuild -p libsecretspec -j $NIX_BUILD_CORES \
      --profile dist --frozen --prefix=${placeholder "out"} \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${buildPackages.rust.envVars.setEnv} cargo cinstall -p libsecretspec -j $NIX_BUILD_CORES \
      --profile dist --frozen --prefix=${placeholder "out"} \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ${buildPackages.rust.envVars.setEnv} cargo ctest -p libsecretspec -j $NIX_BUILD_CORES \
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
            $CC ${finalAttrs.src}/libsecretspec/tests/smoke.c \
              $(pkg-config --cflags --libs libsecretspec) \
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
    pkgConfigModules = [ "libsecretspec" ];
  };
})
