{ rustPlatform
, stdenv
, lib
, fetchFromGitLab
, meson
, cmake
, desktop-file-utils
, automake
, autoconf
, libtool
, libevent
, openssl
, zlib
, pkg-config
, libgee
, curl
, vala
, glib
, python3
, gtk3
, libhandy
, libutp
, miniupnpc
, dht
, libnatpmp
, sqlite
, dbus
, gtk4
, libadwaita
, git
, cargo
, rustc
, hicolor-icon-theme
, libtransmission
, libb64
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "fragments";
  version = "2.0-unstable";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Fragments";
    rev = "020addb3431773da7410e9373e58e7f427eb6886";
    fetchSubmodules = true;
    sha256 = "01i86mff3znblf6sw62wvm2z8nyr47bbg8pzw2h9aqyvrpgz7c3b";
  };

  cargoSha256 = "16sxyrk89lqglkkjkh655s2303cvg4p0ym3z8bjs04xy9nmvzy0w";

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    desktop-file-utils
    libtool
    meson
    pkg-config
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
    libutp
    miniupnpc
    dht
    libnatpmp
    openssl
    zlib
    libtransmission
    libb64
    sqlite
    dbus
    gtk4
    libadwaita
    git
    rustc
    cargo
  ];

  #patches = [ ./find_library.patch ];

  postPatch = ''
    chmod +x build-aux/*
    patchShebangs build-aux
  '';

  dontUseCmakeConfigure = true;

  meta = with lib; {
    description = "An easy to use BitTorrent client which follows the GNOME HIG and includes well thought-out features";
    homepage = https://gitlab.gnome.org/World/Fragments;
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
