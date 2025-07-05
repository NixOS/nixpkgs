{
  lib,
  fetchFromGitHub,
  rustPlatform,
  _experimental-update-script-combinators,
  unstableGitUpdater,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shaperglot-cli";
  version = "0-unstable-2025-06-20";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    rev = "0c521f32f8fe5c927a4aac2236307547fa281972";
    hash = "sha256-V7eBt0m82mW4NALWZeYVJD4TeU5l0kaOJPyDFxRSIUs=";
  };

  cargoHash = "sha256-19amPodlTIxuBue8UT5PfWHUe4evmJsAHcrIAx6YVSk=";

  cargoBuildFlags = [
    "--package=shaperglot-cli"
  ];

  cargoTestFlags = [
    "--package=shaperglot-cli"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    describe_output="$("$out/bin/shaperglot" describe English)"
    [[ "$describe_output" == *'support'* ]]

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (unstableGitUpdater {
        branch = "main";
        # Git tag differs from CLI version: https://github.com/googlefonts/shaperglot/issues/138
        hardcodeZeroVersion = true;
      })
      (nix-update-script {
        # Updating `cargoHash`
        extraArgs = [ "--version=skip" ];
      })
    ];
  };

  meta = {
    description = "Test font files for language support";
    homepage = "https://github.com/googlefonts/shaperglot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "shaperglot";
  };
})
