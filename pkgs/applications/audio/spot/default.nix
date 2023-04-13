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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "xou816";
    repo = "spot";
    rev = version;
    hash = "sha256-K6wGWhAUUGsbE4O+z0TmJcJyGarvHgZteY527jfAa90=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-eM2XLumn4dr2YtyUzBZJADlqdexc1iOaNJUudMlfSUc=";
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
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Native Spotify client for the GNOME desktop";
    homepage = "https://github.com/xou816/spot";
    license = licenses.mit;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;
  };
}
