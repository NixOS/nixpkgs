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
  version = "0-unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    rev = "92878be90fabb7bdd93afd81121f4ed885f33d06";
    hash = "sha256-Hrl/SVmRCEJLk+MR5fA4H0MTjy9hGgrM/HvAK3/lLIc=";
  };

  cargoHash = "sha256-bWdO3YCWxKwgGjDdquY9COT5Ma2rRloOyWj51JZ45BE=";

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
