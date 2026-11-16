{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  testers,
  gnome,
  gobject-introspection,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ministream";
  version = "0.99.1";

  src = fetchurl {
    url = "mirror://gnome/sources/ministream/${lib.versions.majorMinor finalAttrs.version}/ministream-${finalAttrs.version}.tar.xz";
    hash = "sha256-TIY7WI+pofjgu0akNXysVzdoLYLQkilxVokUX8NKrYM=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    glib
  ];

  mesonFlags = [
    (lib.mesonEnable "as-compare" false)
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = gnome.updateScript {
      packageName = "ministream";
    };
  };

  meta = {
    description = "Subset of libappstream for libadwaita";
    longDescription = ''
      Ministream is a small subset of libappstream, intended to be used by
      libadwaita to automatically populate its AboutDialog with data
      contained in the application's AppStream manifest. Unlike libappstream,
      this library only depends on GLib.
    '';
    homepage = "https://gitlab.gnome.org/GNOME/ministream";
    changelog = "https://gitlab.gnome.org/GNOME/ministream/-/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "ministream" ];
  };
})
