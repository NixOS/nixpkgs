{
  stdenvNoCC,
  lib,
  fetchurl,
  makeWrapper,
  gettext,
  meson,
  ninja,
  python3,
  buildPackages,
  gnome,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gweather-locations";
  version = "2026.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gweather-locations/${lib.versions.major finalAttrs.version}/gweather-locations-${finalAttrs.version}.tar.xz";
    hash = "sha256-51cKNmHgp1KgY4eyAyWFz1iPxWdwsfnznxpV0XsoNf4=";
  };

  strictDeps = true;

  depsBuildBuild = [
    makeWrapper
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    (python3.pythonOnBuildForHost.withPackages (ps: [ ps.pygobject3 ]))
  ];

  postPatch = ''
    patchShebangs --build build-aux/gen_locations_variant.py
    wrapProgram $PWD/build-aux/gen_locations_variant.py \
      --prefix GI_TYPELIB_PATH : ${lib.getLib buildPackages.glib}/lib/girepository-1.0
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gweather-locations";
    };
  };

  meta = {
    description = "GWeather locations database";
    homepage = "https://gitlab.gnome.org/GNOME/gweather-locations";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
  };
})
