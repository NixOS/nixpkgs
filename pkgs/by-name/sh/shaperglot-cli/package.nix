{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shaperglot-cli";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VVxOkJ6a5UhQvSCswbgeRCLUEOzAbPhHuhJJAr1VvKA=";
  };

  cargoHash = "sha256-WOIYg/QlWEk1StmudlPjpit/cKMkPtqLtf0BhPWQeg8=";

  cargoBuildFlags = [
    "--package=shaperglot-cli"
  ];

  cargoTestFlags = [
    "--package=shaperglot-cli"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  installCheckPhase = ''
    runHook preInstallCheck

    describe_output="$("$out/bin/shaperglot" describe English)"
    [[ "$describe_output" == *'support'* ]]

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Test font files for language support";
    homepage = "https://github.com/googlefonts/shaperglot";
    # The CHANGELOG.md file exists in this repository but is not actually used.
    changelog = "https://github.com/googlefonts/shaperglot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "shaperglot";
  };
})
