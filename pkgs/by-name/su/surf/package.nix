{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gcr,
  glib-networking,
  gsettings-desktop-schemas,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  xprop,
  dmenu,
  findutils,
  gnused,
  coreutils,
  gst_all_1,
  patches ? null,
}:
stdenv.mkDerivation {
  pname = "surf";
  version = "2.1-unstable-2025-04-19";

  # tarball is missing file common.h
  src = fetchgit {
    url = "git://git.suckless.org/surf";
    rev = "48517e586cdc98bc1af7115674b554cc70c8bc2e";
    hash = "sha256-+qg1mF5X/hYxCy7N3CxIEM2yHi1jmUGiK/vaQBjKy1I=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    glib
    gcr
    glib-networking
    gsettings-desktop-schemas
    libsoup_3
    gtk3
    webkitgtk_4_1
  ]
  ++ (with gst_all_1; [
    # Audio & video support for webkitgtk WebView
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  inherit patches;

  makeFlags = [ "PREFIX=$(out)" ];

  # Add run-time dependencies to PATH. Append them to PATH so the user can
  # override the dependencies with their own PATH.
  preFixup =
    let
      depsPath = lib.makeBinPath [
        xprop
        dmenu
        findutils
        gnused
        coreutils
      ];
    in
    ''
      gappsWrapperArgs+=(
        --suffix PATH : ${depsPath}
        --set GDK_BACKEND x11
      )
    '';

  meta = {
    description = "Simple web browser based on WebKitGTK";
    mainProgram = "surf";
    longDescription = ''
      surf is a simple web browser based on WebKitGTK. It is able to display
      websites and follow links. It supports the XEmbed protocol which makes it
      possible to embed it in another application. Furthermore, one can point
      surf to another URI by setting its XProperties.
    '';
    homepage = "https://surf.suckless.org";
    license = lib.licenses.mit;
    platforms = webkitgtk_4_1.meta.platforms;
    maintainers = [ ];
  };
}
