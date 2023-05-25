{ buildGoModule
, cairo
, fetchFromGitHub
, gdk-pixbuf
, glib
, gobject-introspection
, graphene
, gst_all_1
, gtk4
, lib
, libadwaita
, libcanberra-gtk3
, pango
, pkg-config
, sound-theme-freedesktop
, wrapGAppsHook4
}:

buildGoModule rec {
  pname = "gtkcord4";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WrKZRRJAbEzcCRcFUTa7PxahQ3YADhfWaKlB4uJjVk0=";
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
    # Optional according to upstream but required for sound and video
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    libcanberra-gtk3
    sound-theme-freedesktop
    libadwaita
  ];

  postInstall = ''
    install -D -m 444 -t $out/share/applications nix/xyz.diamondb.gtkcord4.desktop
    install -D -m 444 internal/icons/svg/logo.svg $out/share/icons/hicolor/scalable/apps/gtkcord4.svg
    install -D -m 444 internal/icons/png/logo.png $out/share/icons/hicolor/256x256/apps/gtkcord4.png
  '';

  vendorHash = "sha256-8Xnu3WjaaWMRkqmnQCxSc/SD65XFMIY0xamWDx4jZbw=";

  meta = with lib; {
    description = "GTK4 Discord client in Go, attempt #4.";
    homepage = "https://github.com/diamondburned/gtkcord4";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hmenke urandom aleksana ];
  };
}
