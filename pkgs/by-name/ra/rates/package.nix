{
  lib,
  stdenv,
  darwin,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-qfuCA1kAEbYIYI274lNrEKZNhltQP71CwtsjBr0REJs=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "CLI tool that brings currency exchange rates right into your terminal";
    homepage = "https://github.com/lunush/rates";
    changelog = "https://github.com/lunush/rates/releases/tag/${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "rates";
  };
}
