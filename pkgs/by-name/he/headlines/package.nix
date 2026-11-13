{
  lib,
  stdenv,
  cmake,
  glib,
  glib-networking,
  pkg-config,
  openssl,
  jsoncpp,
  libxml2,
  gst_all_1,
  libadwaita,
  libsecret,
  libsoup_3,
  webkitgtk_6_0,
  fetchFromGitLab,
  wrapGAppsHook4,
  xdg-utils,
}:

stdenv.mkDerivation rec {
  pname = "headlines";
  version = "0.8.0";

  src = fetchFromGitLab {
    owner = "caveman250";
    repo = "Headlines";
    rev = version;
    hash = "sha256-zXGIGbqeljq3rN1p8MxAjqmxmGf95uPAlcFr3QOy3oE=";
  };

  nativeBuildInputs = [
    cmake
    glib
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    openssl
    jsoncpp
    libxml2
    libadwaita
    libsecret
    libsoup_3
    webkitgtk_6_0
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
  ]);

  cmakeFlags = [ (lib.cmakeBool "DIST_BUILD" true) ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}"
    )
  '';

  meta = {
    description = "GTK4 / Libadwaita Reddit client written in C++";
    homepage = "https://gitlab.com/caveman250/Headlines";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chuangzhu ];
    mainProgram = "headlines";
  };
}
