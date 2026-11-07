{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  dbus,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bootvine";
  version = "0-unstable-2026-10-21";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "wvhulle";
    repo = "bootvine";
    rev = "121750eebb39466c7bd785db3224696608288635";
    hash = "sha256-Bda7fuoURIk4Q4sNprsTHwD1Rj3nupixAg6H9ZR+gkE=";
  };

  cargoHash = "sha256-9QrChglbavje4PPyDN3OqrZ4w9p2PRKdM3xywHjSI58=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A boot animation showing stages of systemd as a tree";
    homepage = "https://codeberg.org/wvhulle/bootvine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wvhulle ];
    mainProgram = "bootvine";
  };
})
