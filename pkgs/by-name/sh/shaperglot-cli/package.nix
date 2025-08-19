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
  version = "0-unstable-2025-08-11";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    rev = "b7ba56e583e89a1c169f4ef7c3419e4e76e00974";
    hash = "sha256-XFzsUzHa4KsyDWlOKlWHBNimn1hzdrtCPe+lFrs0EDc=";
  };

  cargoHash = "sha256-Md48ovCG8pEPbTz6R0nks6rZxO3UEdZ/SYRVgffCIKU=";

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
