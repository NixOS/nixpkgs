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
  version = "0.10.4-dev";

  src = fetchFromGitHub {
    owner = "cestef";
    repo = "rwalk";
    tag = "v${version}";
    hash = "sha256-u+mD4L+Vyram1xiaE0Pimj6ZrgME5WRb7sFAQ80zaAk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ghdkGJDLdS0331y3yY0vbW59CHaPDGO/YTKZLr5zYn8=";

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
