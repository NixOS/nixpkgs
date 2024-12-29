{
  lib,
  stdenv,
  fetchurl,
  desktop-file-utils,
  pkg-config,
  gnome,
  adwaita-icon-theme,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  gjs,
  gobject-introspection,
  libgweather,
  meson,
  ninja,
  geoclue2,
  python3,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation rec {
  pname = "gnome-weather";
  version = "47.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-weather/${lib.versions.major version}/gnome-weather-${version}.tar.xz";
    hash = "sha256-UV9YYjdN00bLyFqd3wMGstMnZXhQu2C2ycmGD86WIOY=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    pkg-config
    meson
    ninja
    wrapGAppsHook4
    python3
    gobject-introspection
    gjs
  ];

  buildInputs = [
    gtk4
    libadwaita
    gjs
    libgweather
    adwaita-icon-theme
    geoclue2
    gsettings-desktop-schemas
  ];

  postPatch = ''
    # The .service file is not wrapped with the correct environment
    # so misses GIR files when started. By re-pointing from the gjs
    # entry point to the wrapped binary we get back to a wrapped
    # binary.
    substituteInPlace "data/org.gnome.Weather.service.in" \
        --replace-fail "Exec=@DATA_DIR@/@APP_ID@" "Exec=$out/bin/gnome-weather"

    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-weather"; };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Weather/";
    description = "Access current weather conditions and forecasts";
    mainProgram = "gnome-weather";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
