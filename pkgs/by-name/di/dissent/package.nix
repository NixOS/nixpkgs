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
  pname = "dissent";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = "dissent";
    rev = "v${version}";
    hash = "sha256-HNNTF/a+sLFp+HCxltYRuDssoLnIhzEXuDLKTPxWzeM=";
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
    install -D -m 444 -t $out/share/applications nix/so.libdb.dissent.desktop
    install -D -m 444 internal/icons/hicolor/scalable/apps/so.libdb.dissent.svg $out/share/icons/hicolor/scalable/apps/so.libdb.dissent.svg
  '';

  vendorHash = "sha256-mwY1M81EWfbF/gYXQl5bcEXxN9N1npD+GgUSMc7gy90=";

  meta = with lib; {
    description = "GTK4 Discord client in Go, attempt #4 (formerly gtkcord4)";
    homepage = "https://github.com/diamondburned/dissent";
    license = licenses.gpl3Only;
    mainProgram = "dissent";
    maintainers = with maintainers; [ hmenke urandom aleksana ];
  };
}
