{ lib
, stdenv
<<<<<<< HEAD
, fetchzip
, desktop-file-utils
, intltool
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gssdp_1_6
, gtk3
, gupnp_1_6
=======
, fetchurl
, intltool
, pkg-config
, wrapGAppsHook
, gssdp
, gtk3
, gupnp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "upnp-router-control";
<<<<<<< HEAD
  version = "0.3.3";

  src = fetchzip {
    url = "https://launchpad.net/upnp-router-control/trunk/${version}/+download/upnp-router-control-${version}.tar.xz";
    hash = "sha256-d5NmA1tOQtYPjGXYfH0p9CCnWM+aVTX2KuV36QCDxd8=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    intltool
    meson
    ninja
=======
  version = "0.3.1";

  src = fetchurl {
    url = "https://launchpad.net/upnp-router-control/trunk/${version}/+download/upnp-router-control-${version}.tar.gz";
    hash = "sha256-bYbw4Z5hDlFTSGk5XE2gnnXRPYMl4IzV+kzlwfR98yg=";
  };

  nativeBuildInputs = [
    intltool
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
<<<<<<< HEAD
    gssdp_1_6
    gtk3
    gupnp_1_6
=======
    gssdp
    gtk3
    gupnp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    # also https://gitlab.gnome.org/DnaX/upnp-router-control
    homepage = "https://launchpad.net/upnp-router-control";
    description = "Access some parameters of the router and manage port forwarding";
    longDescription = ''
      A GTK application to access some parameters of the router like:
      the network speed, the external IP and the model name.
      It can manage port forwarding through a simple GUI interface.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
