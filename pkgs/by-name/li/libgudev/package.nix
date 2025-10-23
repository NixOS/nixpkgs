{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  udev,
  glib,
  glibcLocales,
  umockdev,
  gnome,
  vala,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgudev";
  version = "238";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libgudev/${lib.versions.majorMinor finalAttrs.version}/libgudev-${finalAttrs.version}.tar.xz";
    hash = "sha256-YSZqsa/J1z28YKiyr3PpnS/f9H2ZVE0IV2Dk+mZ7XdE=";
  };

  patches = [
    # Conditionally disable one test that requires a locale implementation
    # https://gitlab.gnome.org/GNOME/libgudev/-/merge_requests/31
    ./tests-skip-double-test-on-stub-locale-impls.patch
  ];

  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
    # The relative location of LD_PRELOAD works for Glibc but not for other loaders (e.g. pkgsMusl)
    substituteInPlace tests/meson.build \
      --replace "LD_PRELOAD=libumockdev-preload.so.0" "LD_PRELOAD=${lib.getLib umockdev}/lib/libumockdev-preload.so.0"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    glib # for glib-mkenums needed during the build
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
  ];

  buildInputs = [
    udev
    glib
  ];

  checkInputs = [
    glibcLocales
    umockdev
  ];

  doCheck = withIntrospection;
  mesonFlags = [
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "vapi" withIntrospection)
    (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck)
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libgudev";
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Library that provides GObject bindings for libudev";
    homepage = "https://gitlab.gnome.org/GNOME/libgudev";
    teams = [ teams.gnome ];
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
})
