{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rwalk";
  version = "0.10.5-dev";

  src = fetchFromGitHub {
    owner = "cestef";
    repo = "rwalk";
    tag = "v${version}";
    hash = "sha256-43Z8dc2bl4pZkUpfRgYjZhlzaPM50bBTZOInd37Be0w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-jxk2nybPD3WTGWDv3DHv0W63MrTcvIz8bxpCwp9R9Zk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Blazingly fast web directory scanner written in Rust";
    homepage = "https://github.com/cestef/rwalk";
    changelog = "https://github.com/cestef/rwalk/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pwnwriter ];
    mainProgram = "rwalk";
  };
}
