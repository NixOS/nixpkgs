{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
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

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    glib
  ];

  mesonFlags = [
    "-Das-compare=disabled"
    (lib.mesonEnable "introspection" withIntrospection)
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = finalAttrs.pname;
    };
  };

  meta = {
    description = "Subset of libappstream for libadwaita";
    longDescription = ''
      Ministream is a small subset of libappstream, intended to be used by
      libadwaita to automatically populate its AboutDialog with data
      contained in the applications AppStream manifest. Unlike libappstream,
      this library only depends on GLib.
    '';
    homepage = "https://gitlab.gnome.org/GNOME/ministream";
    changelog = "https://gitlab.gnome.org/GNOME/ministream/-/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
})
