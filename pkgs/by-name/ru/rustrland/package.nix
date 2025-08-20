{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustrland";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "mattdef";
    repo = "rustrland";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-sT4XSYrBxjVTd+xMcCqi24k/TbIRX4p8lEgrf/Wj1z8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  # Skip building examples that have compilation issues
  cargoBuildFlags = [ "--bins" ];
  cargoTestFlags = [ "--bins" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust-powered window management for Hyprland";
    homepage = "https://github.com/mattdef/rustrland";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mattdef ];
    mainProgram = "rustrland";
  };
})
