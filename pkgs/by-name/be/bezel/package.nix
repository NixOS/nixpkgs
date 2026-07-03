{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  nix-update-script,
  runtimeShell,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bezel";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Indra55";
    repo = "bezel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6pItHoEZCJi7Zo89HGzLNqNX+JzM69xBaZbuB3vrPDI=";
  };

  cargoHash = "sha256-pClznWnPGJyP2j4Pn8M7dwtBgUXrA42GYvT54YSzXWE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  postPatch = ''
    substituteInPlace src/dispatcher.rs \
      --replace-fail '"sh"' '"${runtimeShell}"'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Per-edge-zone trackpad gesture daemon";
    longDescription = ''
      Bezel is a daemon that provides customizable trackpad edge
      gestures.  It intercepts raw trackpad inputs via `evdev` and
      dispatches shell commands based on directional swipes or taps
      along the edges (zones) of your trackpad.
    '';
    changelog = "https://github.com/Indra55/bezel/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/Indra55/bezel";
    license = lib.licenses.gpl3Plus;
    mainProgram = "bezel";
    maintainers = with lib.maintainers; [
      olimoli
      yiyu
    ];
    platforms = lib.platforms.linux;
  };
})
