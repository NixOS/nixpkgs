{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  dbus,
  systemdLibs,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bootvine";
  version = "0.1.3";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "wvhulle";
    repo = "bootvine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WzqLbOcOokwn2XT62YdD3llWZbNhMl/STbJb2Yn2/pQ=";
  };

  cargoHash = "sha256-uoWys8kdGUZ3YeriNLsU8we/kSTvCswQkzdnhTIEtCY=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://codeberg.org/wvhulle/bootvine/releases/tag/${finalAttrs.src.tag}";
    description = "Boot animation showing stages of systemd as a tree";
    homepage = "https://codeberg.org/wvhulle/bootvine";
    license = lib.licenses.mit;
    mainProgram = "bootvine";
    maintainers = with lib.maintainers; [ wvhulle ];
    platforms = lib.platforms.linux;
  };
})
