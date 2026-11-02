{
  lib,
  dbus,
  fetchFromGitHub,
  makeWrapper,
  rustPlatform,
  spotifyd,
  systemd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spotify-tui";
  version = "0.1.0-unstable-2026-11-02";

  src = fetchFromGitHub {
    owner = "kylescudder";
    repo = "spotify-tui";
    rev = "fb6f0193a9e1bb89384a3e9e59fa58163c66b172";
    hash = "sha256-L1tyC1jLhKM8AK2XtM9y/VSyGG6GriIVL+bjqShQH58=";
  };

  cargoHash = "sha256-po+Nbj8wZKQN4Uz+GArrEPHf3Z9rXyzygNgQ/IpJDIk=";

  # Shown by `spotify-tui --version`.
  env.SPOTIFY_TUI_BUILD_REVISION = builtins.substring 0 7 finalAttrs.src.rev;

  nativeBuildInputs = [ makeWrapper ];

  # The Linux playback adapter tests start a private D-Bus session.
  nativeCheckInputs = [ dbus ];

  postInstall = ''
    install -Dm644 themes/*.toml -t $out/share/spotify-tui/themes
    wrapProgram $out/bin/spotify-tui \
      --prefix PATH : ${
        lib.makeBinPath [
          spotifyd
          systemd
        ]
      } \
      --set-default SPOTIFY_TUI_SPOTIFYD ${lib.getExe spotifyd}
  '';

  meta = {
    description = "Local-first terminal Spotify interface powered by spotifyd";
    homepage = "https://github.com/kylescudder/spotify-tui";
    license = lib.licenses.mit;
    mainProgram = "spotify-tui";
    maintainers = with lib.maintainers; [ kylescudder ];
    platforms = lib.platforms.linux;
  };
})
