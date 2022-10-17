{ lib
, stdenv
, fetchurl
, intltool
, pkg-config
, wrapGAppsHook
, gssdp
, gtk3
, gupnp
}:

stdenv.mkDerivation rec {
  pname = "upnp-router-control";
  version = "0.3.1";

  src = fetchurl {
    url = "https://launchpad.net/upnp-router-control/trunk/${version}/+download/upnp-router-control-${version}.tar.gz";
    hash = "sha256-bYbw4Z5hDlFTSGk5XE2gnnXRPYMl4IzV+kzlwfR98yg=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gssdp
    gtk3
    gupnp
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
