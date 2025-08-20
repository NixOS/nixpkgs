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
  version = "0-unstable-2025-08-15";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    rev = "814324e00bf732f2d73ff205680b1cc2bb3a87c5";
    hash = "sha256-UF7c4ZS603uarghmD3XCc6QKo1HBLR0kmyhLn/pSYKM=";
  };

  cargoHash = "sha256-rGQhJm5HvUUJaSy2z3FnWblHFeJMoyTLmsH+ZKYDkCQ=";

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
