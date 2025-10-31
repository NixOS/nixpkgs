{
  lib,
  stdenv,
  fetchurl,
  ninja,
  meson,
  mesonEmulatorHook,
  pkg-config,
  vala,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  gi-docgen,
  glib,
  libgudev,
  libevdev,
  hidapi,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmanette";
  version = "0.2.13";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/libmanette/${lib.versions.majorMinor finalAttrs.version}/libmanette-${finalAttrs.version}.tar.xz";
    hash = "sha256-KHzC/eDeCSkZNmr3V9heezoCSOsbOVNEcm6XlVp32K4=";
  };

  depsBuildBuild = lib.optionals withIntrospection [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
  ]
  ++ lib.optionals withIntrospection [
    vala
    gobject-introspection
    gi-docgen
  ]
  ++ lib.optionals (withIntrospection && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    libevdev
    hidapi
  ]
  ++ lib.optionals withIntrospection [
    libgudev
  ];

  mesonFlags = [
    (lib.mesonBool "doc" withIntrospection)
    (lib.mesonEnable "gudev" withIntrospection)
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "vapi" withIntrospection)
  ];

  doCheck = true;
  strictDeps = true;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libmanette";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Simple GObject game controller library";
    mainProgram = "manette-test";
    homepage = "https://gnome.pages.gitlab.gnome.org/libmanette/";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
})
