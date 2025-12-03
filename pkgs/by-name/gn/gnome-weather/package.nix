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
  typescript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-weather";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-weather/${lib.versions.major finalAttrs.version}/gnome-weather-${finalAttrs.version}.tar.xz";
    hash = "sha256-7h92uF66nbDI1cAgQanYXs3SKrtexrs/8yIlkpwPzl8=";
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
    typescript
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
    updateScript = gnome.updateScript {
      packageName = "gnome-weather";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Weather/";
    description = "Access current weather conditions and forecasts";
    mainProgram = "gnome-weather";
    teams = [ teams.gnome ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
})
