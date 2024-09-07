{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  libadwaita,
}:

buildGoModule rec {
  pname = "multiplex";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "pojntfx";
    repo = "multiplex";
    rev = "v${version}";
    hash = "sha256-6xZ46LeFuJXwd7s63YKekUIdb8ytdLk+rp+tFox27zY=";
  };

  vendorHash = "sha256-S14dMAejoVTVn3rRdZyG+npM5kNehHwntJkeW3M7Stk=";

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  # recursively generate all files requested by go:generate
  preBuild = ''
    go generate ./...
  '';

  postInstall = ''
    install -Dm644 -t $out/share/applications com.pojtinger.felicitas.Multiplex.desktop
    install -Dm644 -t $out/share/metainfo com.pojtinger.felicitas.Multiplex.metainfo.xml
    # The provided pixmap icons appears to be a bit blurry so not installing them
    install -Dm644 docs/icon.svg $out/share/icons/hicolor/scalable/apps/com.pojtinger.felicitas.Multiplex.svg
    install -Dm644 docs/icon-symbolic.svg $out/share/icons/hicolor/symbolic/apps/com.pojtinger.felicitas.Multiplex-symbolic.svg
  '';

  meta = {
    description = "Watch torrents with your friends";
    longDescription = ''
      Multiplex is an app to watch torrents together, providing an experience similar
      to Apple's SharePlay and Amazon's Prime Video Watch Party.

      It enables you to:
      - Stream any file directly using a wide range of video and audio formats with
        the mpv video player.
      - Host online watch parties while preserving your privacy by synchronizing
        video playback with friends without a central server using weron.
      - Bypass internet restrictions by optionally separating the hTorrent HTTP to
        BitTorrent gateway and user interface into two separate components.
    '';
    homepage = "https://github.com/pojntfx/multiplex";
    license = with lib.licenses; [
      agpl3Plus
      cc0
    ];
    mainProgram = "multiplex";
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
