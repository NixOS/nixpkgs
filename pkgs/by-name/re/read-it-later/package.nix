{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, meson
, ninja
, pkg-config
, rustc
, cargo
, wrapGAppsHook4
, desktop-file-utils
, libxml2
, libadwaita
, openssl
, libsoup_3
, webkitgtk_6_0
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "read-it-later";
  version = "0.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    hash = "sha256-A8u1fecJAsVlordgZmUJt/KZWxx6EWMhfdayKWHTTFY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-wK7cegcjiu8i1Grey6ELoqAn2BrvElDXlCwafTLuFv0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    desktop-file-utils
    libxml2.bin #xmllint
  ];

  buildInputs = [
    libadwaita
    openssl
    libsoup_3
    webkitgtk_6_0
    sqlite
  ];

  meta = with lib; {
    description = "A simple Wallabag client with basic features to manage articles";
    homepage = "https://gitlab.gnome.org/World/read-it-later";
    license = licenses.gpl3Plus;
    mainProgram = "read-it-later";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
