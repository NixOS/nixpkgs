{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, gettext
, python3
, desktop-file-utils
, rustPlatform
, pkg-config
, glib
, libadwaita
, libhandy
, gtk4
, openssl
, alsa-lib
, libpulseaudio
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "spot";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "xou816";
    repo = "spot";
    rev = version;
    hash = "sha256-uZzylK9imEazwC/ogsDO8ZBvByE5/SNSV+mIlp7Z9Ww=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-v5xdlsI6OlEpCYOTFePTyI8BkIrAwT6FR2JwiRTGgOA=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3 # for meson postinstall script
    gtk4 # for gtk-update-icon-cache
    glib # for glib-compile-schemas
    desktop-file-utils
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libhandy
    openssl
    alsa-lib
    libpulseaudio
  ];

  # https://github.com/xou816/spot/issues/313
  mesonBuildType = "release";

  postPatch = ''
    chmod +x build-aux/cargo.sh
    patchShebangs build-aux/cargo.sh build-aux/meson/postinstall.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Native Spotify client for the GNOME desktop";
    homepage = "https://github.com/xou816/spot";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar tomfitzhenry ];
  };
}
