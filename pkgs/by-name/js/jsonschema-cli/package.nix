{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
  runCommand,
  testers,
  jsonschema-cli,
}:

rustPlatform.buildRustPackage rec {
  pname = "jsonschema-cli";
  version = "0.29.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-kpdvvCnMsHfogXmAqNeo1Cl1hZtCPHqkfhYm8ipWToo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Yti1KKJDRXMhDo84/ymZk2AkWp9HtU2LW2h63gfzIGY=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = [ "--version" ];

  passthru = {
    tests = {
      simple = runCommand "${pname}-test" { } ''
        ${lib.getExe jsonschema-cli} <(echo '{"maxLength": 5}') --instance <(echo '"exact"') > $out
      '';

      failed =
        runCommand "${pname}-fail"
          {
            failed = testers.testBuildFailure (
              runCommand "fail" { } ''
                ${lib.getExe jsonschema-cli} <(echo '{"maxLength": 5}') --instance <(echo '"longer"') > $out
              ''
            );
          }
          ''
            grep -F '"longer" is longer than 5 characters' $failed/result
            [[ 1 = $(cat $failed/testBuildFailure.exit) ]]
            touch $out
          '';
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast command-line tool for JSON Schema validation";
    homepage = "https://github.com/Stranger6667/jsonschema";
    changelog = "https://github.com/Stranger6667/jsonschema/releases/tag/rust-v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "jsonschema-cli";
  };
}
