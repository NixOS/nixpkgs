{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  dbus,
  systemdLibs,
  nix-update-script,
  versionCheckHook,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bootvine";
  version = "0.1.4";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "wvhulle";
    repo = "bootvine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-47+MgKwFUErTiop+xab4F4AY0HqOZHCZy/OSoUo5Eqs=";
  };

  cargoHash = "sha256-yUq+gUSFaDNlkEv8nEpKYFYMTSelunTEfQHnvFt1osY=";

  cargoBuildFlags = [
    "--bin"
    "bootvine"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    systemdLibs
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
    tests.nixos = nixosTests.bootvine;
  };

  meta = {
    changelog = "https://codeberg.org/wvhulle/bootvine/releases/tag/${finalAttrs.src.tag}";
    description = "Boot animation showing stages of systemd as a tree";
    homepage = "https://codeberg.org/wvhulle/bootvine";
    license = lib.licenses.gpl3Plus;
    mainProgram = "bootvine";
    maintainers = with lib.maintainers; [ wvhulle ];
    platforms = lib.platforms.linux;
  };
})
