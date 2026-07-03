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
  version = "0.1.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Indra55";
    repo = "bezel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-//fJVlS8I7r3xoqTw8y+XKuTeAdaWesiM6ArQeDKP40=";
  };

  cargoHash = "sha256-xP48kWdtcH46evxj2OALNRC6eYWauUT0qkpau9kPAt0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  postPatch = ''
    substituteInPlace src/dispatcher.rs \
      --replace '"sh"' '"${runtimeShell}"'
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
