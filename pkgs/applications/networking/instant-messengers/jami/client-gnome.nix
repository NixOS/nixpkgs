{ version
, src
, jami-meta
, stdenv
, lib
, pkg-config
, cmake
, wrapQtAppsHook
, wrapGAppsHook
, gtk3-x11
, networkmanager # for libnm
, libayatana-appindicator
, libnotify
, clutter-gtk
, libcanberra-gtk3
, webkitgtk
, qrencode
, jami-libclient
, qttools
}:

stdenv.mkDerivation {
  pname = "jami-client-gnome";
  inherit version src;

  sourceRoot = "source/client-gnome";

  preConfigure = ''
    echo ${version} > version.txt
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapGAppsHook
    wrapQtAppsHook
  ];
  # To spare double wrapping
  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
    # Users that set CLUTTER_BACKEND=wayland in their default environment will
    # encounter a segfault due to:
    # https://git.jami.net/savoirfairelinux/jami-client-gnome/-/issues/1100 .
    qtWrapperArgs+=("--unset" "CLUTTER_BACKEND")
  '';

  buildInputs = [
    qttools
    jami-libclient
    gtk3-x11
    networkmanager
    libayatana-appindicator
    libnotify
    clutter-gtk
    libcanberra-gtk3
    webkitgtk
    qrencode
  ];

  meta = jami-meta // {
    description = "The client based on GTK" + jami-meta.description;
  };
}
