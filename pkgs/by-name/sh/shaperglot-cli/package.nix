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
  version = "0-unstable-2025-05-27";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    rev = "0d934110dfdf315761255e34040f207f7d7868b5";
    hash = "sha256-5Bgvx4Yv74nQLd037L5uBj6oySqqp947LI/6yGwYSKY=";
  };

  cargoHash = "sha256-UMPoPNpyM/+1rq4U6xQ1DF4W+51p5YjQXr/8zLiPvEI=";

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
