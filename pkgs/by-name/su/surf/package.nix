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
  gtk2,
  libsoup_2_4,
  webkitgtk_4_0,
  xorg,
  dmenu,
  findutils,
  gnused,
  coreutils,
  gst_all_1,
  patches ? null,
}:

stdenv.mkDerivation rec {
  pname = "surf";
  version = "2.1";

  # tarball is missing file common.h
  src = fetchgit {
    url = "git://git.suckless.org/surf";
    rev = version;
    sha256 = "1v926hiayddylq79n8l7dy51bm0dsa9n18nx9bkhg666cx973x4z";
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
    gtk2
    libsoup_2_4
    webkitgtk_4_0
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
        xorg.xprop
        dmenu
        findutils
        gnused
        coreutils
      ];
    in
    ''
      gappsWrapperArgs+=(
        --suffix PATH : ${depsPath}
      )
    '';

  meta = with lib; {
    description = "Simple web browser based on WebKitGTK";
    mainProgram = "surf";
    longDescription = ''
      surf is a simple web browser based on WebKitGTK. It is able to display
      websites and follow links. It supports the XEmbed protocol which makes it
      possible to embed it in another application. Furthermore, one can point
      surf to another URI by setting its XProperties.
    '';
    homepage = "https://surf.suckless.org";
    license = licenses.mit;
    platforms = webkitgtk_4_0.meta.platforms;
    maintainers = with maintainers; [ joachifm ];
  };
}
