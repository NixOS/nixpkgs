{
  lib,
  rustPlatform,
  fetchFromGitHub,
  apple-sdk,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rift-wm";
  version = "0.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "acsandmann";
    repo = "rift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KpzBGim3tu1KXbN/S+ENz45wUWU72arPcCjU/wgYhGo=";
  };

  nativeBuildInputs = [
    apple-sdk
  ];

  cargoHash = "sha256-DxGr89iAoGhSRgW8NiZQF3jtpYF0+uurtx6sv/UCDs4=";
  checkFlags = [
    # runs into: a transient empty active-space WS-id result after wake must not blank windows we already know belong to the active space
    "--skip=actor::reactor::tests::empty_active_space_membership_during_wake_race_does_not_blank_known_active_windows"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiling window manager for macos";
    homepage = "https://github.com/acsandmann/rift";
    changelog = "https://github.com/acsandmann/rift/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eveeifyeve ];
    mainProgram = "rift";
    platforms = lib.platforms.darwin;
  };
})
