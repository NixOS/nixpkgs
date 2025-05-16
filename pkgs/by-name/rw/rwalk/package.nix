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
  version = "0.10.3-dev";

  src = fetchFromGitHub {
    owner = "cestef";
    repo = "rwalk";
    tag = "v${version}";
    hash = "sha256-eVqRXaZUwTwhePV2FrbqVmghQU9pUDDRB6eiVDPWd44=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mQvf+IXj6QaZ8UouThsQMZt7Lioy5iXkKf9UMxhkwYw=";

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
