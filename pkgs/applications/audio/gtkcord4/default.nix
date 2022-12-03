{ buildGoModule
, cairo
, fetchFromGitHub
, gdk-pixbuf
, glib
, gobject-introspection
, graphene
, gtk4
, lib
, pango
, pkg-config
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
  ];

  vendorHash = "sha256-QZSjSk1xu5ZcrNEra5TxnUVvlQWb5/h31fm5Nc7WMoI=";

  meta = with lib; {
    description = "GTK4 Discord client in Go, attempt #4.";
    homepage = "https://github.com/diamondburned/gtkcord4";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hmenke urandom ];
  };
}
