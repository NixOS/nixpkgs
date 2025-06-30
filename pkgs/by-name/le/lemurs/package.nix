{
  fetchFromGitHub,
  lib,
  bash,
  linux-pam,
  rustPlatform,
  systemdMinimal,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "lemurs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "coastalwhite";
    repo = "lemurs";
    tag = "v${version}";
    hash = "sha256-dtAmgzsUhn3AfafWbCaaog0S1teIy+8eYtaHBhvLfLI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XoGtIHYCGXNuwnpDTU7NbZAs6rCO+69CAG89VCv9aAc=";

  buildInputs = [
    bash
    linux-pam
    systemdMinimal
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Customizable TUI display/login manager written in Rust";
    homepage = "https://github.com/coastalwhite/lemurs";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      jeremiahs
      nullcube
    ];
    mainProgram = "lemurs";
  };
}
