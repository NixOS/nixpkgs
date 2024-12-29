{
  lib,
  fetchFromGitHub,
  rustPlatform,

  pkg-config,
  glib,
  pango,
  gtk3,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprwall";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "hyprutils";
    repo = "hyprwall";
    rev = "refs/tags/v${version}";
    hash = "sha256-dzPd+5cws3hKhdd1CKKEO7EWMS0XW0y1vqxg1XKX+gY=";
  };

  cargoHash = "sha256-gT2ysWHckcUl1yx5tciy6kSvZZ0srrs4OwI1mr/58Pc=";

  nativeBuildInputs = [
    pkg-config
    glib
    pango
    wrapGAppsHook4
  ];

  # Required in build process, prevents gdk-sys build error.
  buildInputs = [
    gtk3
  ];

  postInstall = ''
    install -Dm644 hyprwall.desktop -t $out/share/applications
    install -Dm644 hyprwall.png -t $out/share/pixmaps
    substituteInPlace "$out/share/applications/hyprwall.desktop" \
      --replace-fail 'Exec=/usr/bin/hyprwall' "Exec=hyprwall"
  '';

  meta = {
    description = "GUI for setting wallpapers with hyprpaper";
    homepage = "https://github.com/hyprutils/hyprwall";
    changelog = "https://github.com/hyprutils/hyprwall/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "hyprwall";
    platforms = lib.platforms.linux;
  };
}
