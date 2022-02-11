{ lib
, stdenv
, fetchFromGitLab
, meson
, vala
, ninja
, pkg-config
, wrapGAppsHook
, desktop-file-utils
, appstream-glib
, python3
, glib
, gtk3
, libhandy
, libtransmission
, libb64
, libutp
, miniupnpc
, dht
, libnatpmp
, libevent
, curl
, openssl
, zlib
}:

stdenv.mkDerivation rec {
  pname = "fragments";
  version = "1.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Fragments";
    rev = version;
    sha256 = "0x1kafhlgyi65l4w67c24r8mpvasg3q3c4wlgnjc9sxvp6ki7xbn";
  };

  patches = [
    # Fix dependency resolution
    ./dependency-resolution.patch
  ];

  nativeBuildInputs = [
    meson
    vala
    ninja
    pkg-config
    wrapGAppsHook
    desktop-file-utils
    appstream-glib
    python3
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
    libtransmission
    libb64
    libutp
    miniupnpc
    dht
    libnatpmp
    libevent
    curl
    openssl
    zlib
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Fragments";
    description = "A GTK3 BitTorrent Client";
    maintainers = with maintainers; [ emilytrau ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
