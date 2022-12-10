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
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "spot";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "xou816";
    repo = "spot";
    rev = version;
    hash = "sha256-0iuLZq9FSxaOchxx6LzGwpY8qnOq2APl/qkBYzEV2uw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-g46BkrTv6tdrGe/p245O4cBoPjbvyRP7U6hH1Hp4ja0=";
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
    wrapGAppsHook4
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
    substituteInPlace build-aux/meson/postinstall.py \
      --replace gtk-update-icon-cache gtk4-update-icon-cache
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
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;
  };
}
