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
  version = "2.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Fragments";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-3/v+MK7Zzn2tnUOe5cW35I5nJ+EsMUaqzTr25EloJ/k=";
  };

  cargoSha256 = "sha256-Js1UOPIegmQ8rJSPRen1knv0ngoVZXgAHsMbsm0tLcM=";

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
    homepage = https://gitlab.gnome.org/World/Fragments;
    description = "A GTK BitTorrent Client";
    maintainers = with maintainers; [
      onny
      angustrau
    ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}

