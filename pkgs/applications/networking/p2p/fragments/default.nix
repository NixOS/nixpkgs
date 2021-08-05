{ stdenv
, lib
, fetchgit
, meson
, ninja
, cmake
, desktop-file-utils
, automake
, autoconf
, libtool
, libevent
, openssl
, zlib
, pkgconfig
, libgee
, curl
, vala
, glib
, python3
, gtk3
, libhandy
, hicolor-icon-theme
, libtransmission
, libb64
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "fragments";
  version = "1.5";

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/Fragments";
    rev = version;
    fetchSubmodules = true;
    sha256 = "0x1kafhlgyi65l4w67c24r8mpvasg3q3c4wlgnjc9sxvp6ki7xbn";
  };

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    desktop-file-utils
    libtool
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    curl
    glib
    gtk3
    hicolor-icon-theme
    libevent
    libgee
    libhandy
    openssl
    zlib
    libtransmission
    libb64
  ];

  patches = [ ./find_library.patch ];

  postPatch = ''
    chmod +x build-aux/*
    patchShebangs build-aux
  '';

  dontUseCmakeConfigure = true;

  meta = with lib; {
    description = "An easy to use BitTorrent client which follows the GNOME HIG and includes well thought-out features";
    homepage = https://gitlab.gnome.org/World/Fragments;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
