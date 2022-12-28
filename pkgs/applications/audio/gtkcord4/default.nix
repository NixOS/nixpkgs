{ buildGoModule
, cairo
, fetchFromGitHub
, gdk-pixbuf
, glib
, gobject-introspection
, graphene
, gtk4
, lib
, libadwaita
, pango
, pkg-config
, withLibadwaita ? false
, wrapGAppsHook4
}:

buildGoModule rec {
  pname = "gtkcord4";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uEG1pAHMQT+C/E5rKByflvL0NNkC8SeSPMAXanzvhE4=";
  };

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    graphene
    gtk4
    pango
  ] ++ lib.optionals withLibadwaita [
    libadwaita
  ];

  tags = lib.optionals withLibadwaita [ "libadwaita" ];

  postInstall = ''
    install -D -m 444 -t $out/share/applications .nix/com.github.diamondburned.gtkcord4.desktop
    install -D -m 444 internal/icons/svg/logo.svg $out/share/icons/hicolor/scalable/apps/gtkcord4.svg
    install -D -m 444 internal/icons/png/logo.png $out/share/icons/hicolor/256x256/apps/gtkcord4.png
  '';

  vendorHash = "sha256-QZSjSk1xu5ZcrNEra5TxnUVvlQWb5/h31fm5Nc7WMoI=";

  meta = with lib; {
    description = "GTK4 Discord client in Go, attempt #4.";
    homepage = "https://github.com/diamondburned/gtkcord4";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hmenke urandom ];
  };
}
