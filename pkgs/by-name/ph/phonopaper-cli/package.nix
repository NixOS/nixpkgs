{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "phonopaper-cli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "evenfurther";
    repo = "phonopaper-rs";
    tag = "${pname}-v${version}";
    hash = "sha256-nJmlNNK2cDtw6ixLEQhZSYJh19wjFTUbMzmCecPPQS0=";
  };

  cargoHash = "sha256-NPa5HKEvydD1b2rmyQOKtL7w2jHOqT2QTUULwPnJUw4=";

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Encode and decode audio in the PhonoPaper format";
    homepage = "https://github.com/evenfurther/phonopaper-rs";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ samueltardieu ];
    mainProgram = "phonopaper";
  };
}
