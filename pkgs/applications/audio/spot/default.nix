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
, libhandy
, gtk3
, openssl
, alsa-lib
, libpulseaudio
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "spot";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "xou816";
    repo = "spot";
    rev = version;
    sha256 = "eHhbm1amTx3ngqsP32uDEdrhrBeurMftg5SToTQGX9o=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-jY7pWoY9IJi5hHVRS1gQKb+Vmfc+wxHvoAwupOtXXQs=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3 # for meson postinstall script
    gtk3 # for gtk-update-icon-cache
    glib # for glib-compile-schemas
    desktop-file-utils
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
    openssl
    alsa-lib
    libpulseaudio
  ];

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
    maintainers = with maintainers; [ jtojnar ];
  };
}
