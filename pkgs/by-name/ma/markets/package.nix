{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  glib,
  gtk3,
  meson,
  ninja,
  pkg-config,
  python3,
  vala,
  wrapGAppsHook3,
  glib-networking,
  gobject-introspection,
  json-glib,
  libgee,
  libhandy,
  libsoup,
}:

stdenv.mkDerivation rec {
  pname = "markets";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "bitstower";
    repo = "markets";
    rev = version;
    sha256 = "sha256-/g/r/1i69PmPND40zIID3Nun0I4ZFT1EFoNf1qprBjI=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk3
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs = [
    glib
    glib-networking
    gtk3
    json-glib
    libgee
    libhandy
    libsoup
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  postInstall = ''
    ln -s bitstower-markets $out/bin/markets
  '';

  meta = with lib; {
    homepage = "https://github.com/bitstower/markets";
    description = "Stock, currency and cryptocurrency tracker";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
