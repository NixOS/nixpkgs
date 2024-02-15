{ lib
, stdenv
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
}:

stdenv.mkDerivation rec {
  pname = "upnp-router-control";
  version = "0.3.4";

  src = fetchzip {
    url = "https://launchpad.net/upnp-router-control/trunk/${version}/+download/upnp-router-control-${version}.tar.xz";
    hash = "sha256-28F/OB2fHemn7HLVFEDmefRA5AsEaQKy+Qbcv75z9w0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    intltool
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gssdp_1_6
    gtk3
    gupnp_1_6
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
    mainProgram = "upnp-router-control";
  };
}
