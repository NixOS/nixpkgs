{
  fetchFromGitHub,
  lib,
  bash,
  linux-pam,
  rustPlatform,
  systemdMinimal,
  versionCheckHook,
  nixosTests,
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

  cargoHash = "sha256-XoGtIHYCGXNuwnpDTU7NbZAs6rCO+69CAG89VCv9aAc=";

  buildInputs = [
    bash
    linux-pam
    systemdMinimal
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests = {
    inherit (nixosTests)
      lemurs
      lemurs-wayland
      lemurs-wayland-script
      lemurs-xorg
      lemurs-xorg-script
      ;
  };

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
