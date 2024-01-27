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
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fvY55N7AyCasT1Nxi37AtbyGQ4qC/764WgfCmwFa1YQ=";
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
    install -D -m 444 -t $out/share/applications nix/so.libdb.gtkcord4.desktop
    install -D -m 444 internal/icons/hicolor/scalable/apps/logo.svg $out/share/icons/hicolor/scalable/apps/gtkcord4.svg
  '';

  vendorHash = "sha256-dMrdbUAU87wmnRDlJukG6w4PZ2DKx2v68gxNW5Ewijk=";

  meta = with lib; {
    description = "GTK4 Discord client in Go, attempt #4";
    homepage = "https://github.com/diamondburned/gtkcord4";
    license = licenses.gpl3Only;
    mainProgram = "gtkcord4";
    maintainers = with maintainers; [ hmenke urandom aleksana ];
  };
}
