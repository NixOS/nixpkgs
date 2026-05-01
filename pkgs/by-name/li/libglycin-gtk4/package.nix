{
  lib,
  stdenv,
  cargo,
  fontconfig,
  gi-docgen,
  glib,
  gobject-introspection,
  gtk4,
  lcms2,
  libglycin,
  libseccomp,
  meson,
  ninja,
  pkg-config,
  python3,
  rustPlatform,
  rustc,
  vala,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libglycin-gtk4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  inherit (libglycin) version src cargoDeps;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustc
    cargo
    python3
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optionals withIntrospection [
    vala
    gi-docgen
    gobject-introspection
  ];

  buildInputs = [
    fontconfig
    glib
    libseccomp
    lcms2
    gtk4
  ];

  propagatedBuildInputs = [
    libglycin
    gtk4
    # TODO: these should not be required by .pc file
    fontconfig
    libseccomp
    lcms2
  ];

  mesonFlags = [
    (lib.mesonBool "glycin-loaders" false)
    (lib.mesonBool "glycin-thumbnailer" false)
    (lib.mesonBool "libglycin" false)
    (lib.mesonBool "libglycin-gtk4" true)
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "vapi" withIntrospection)
    (lib.mesonBool "capi_docs" withIntrospection)
  ];

  postPatch = ''
    patchShebangs \
      build-aux/crates-version.py
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    description = "C-Bindings to convert glycin frames to GDK Textures";
    homepage = "https://gitlab.gnome.org/GNOME/glycin";
    license = with lib.licenses; [
      mpl20 # or
      lgpl21Plus
    ];
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "glycin-gtk4-1"
    ];
  };
})
