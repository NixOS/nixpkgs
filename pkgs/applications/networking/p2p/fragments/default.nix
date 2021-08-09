{ rustPlatform
, stdenv
, lib
, fetchFromGitLab
, meson
, cmake
, desktop-file-utils
, ninja
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
, sqlite
, dbus
, gtk4
, libadwaita
, git
, cargo
, gettext
, rustc
, transmission
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

  cargoSha256 = "0s8vmyf3fqwz4nyqxs0l9q2g20pqhbzi7vfzp8z8xncsva0jsn5k";

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
    gettext
    glib
    ninja
  ];

  buildInputs = [
    meson
    curl
    gtk3
    hicolor-icon-theme
    libevent
    libgee
    libhandy
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

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  doCheck = true;
  checkPhase = null;
  installPhase = null;

  postPatch = ''
    chmod +x build-aux/*
    patchShebangs build-aux
  '';

  dontUseCmakeConfigure = true;

  postInstall = ''
    wrapProgram $out/bin/fragments \
        --set PATH ${lib.makeBinPath [ transmission ]}
  '';

  meta = with lib; {
    description = "An easy to use BitTorrent client which follows the GNOME HIG and includes well thought-out features";
    homepage = https://gitlab.gnome.org/World/Fragments;
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
