{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bezel";
  version = "0.1.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Indra55";
    repo = "bezel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z//Twj5quYB9g218MwUFjRwxfwr3Vj1ip6jQaqnnRpQ=";
  };

  cargoHash = "sha256-QqtemXdIlGT095Jx5sZmoE8uWiA51hNzwjHvDWIi9gs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ udev ];

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
