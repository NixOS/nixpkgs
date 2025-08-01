{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "rates";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lunush";
    repo = "rates";
    tag = version;
    hash = "sha256-zw2YLTrvqbGKR8Dg5W+kJTDKIfro+MNyjHXfZMXZhaw=";
  };

  cargoHash = "sha256-qfuCA1kAEbYIYI274lNrEKZNhltQP71CwtsjBr0REJs=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  meta = {
    description = "CLI tool that brings currency exchange rates right into your terminal";
    homepage = "https://github.com/lunush/rates";
    changelog = "https://github.com/lunush/rates/releases/tag/${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rates";
  };
}
