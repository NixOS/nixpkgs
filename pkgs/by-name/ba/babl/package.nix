{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  lcms2,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  gi-docgen,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "babl";
  version = "0.1.114";

  outputs =
    [
      "out"
      "dev"
    ]
    ++ lib.optionals withIntrospection [
      "devdoc"
    ];

  src = fetchurl {
    url = "https://download.gimp.org/pub/babl/${lib.versions.majorMinor finalAttrs.version}/babl-${finalAttrs.version}.tar.xz";
    hash = "sha256-vLt3hsHkR3A9s7x/o01i0NLRF7IvBNiDTHstXe1FZIc=";
  };

  patches = [
    # Allow overriding path to dev output that will be hardcoded e.g. in pkg-config file.
    ./dev-prefix.patch
  ];

  strictDeps = true;

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config

    ]
    ++ lib.optionals withIntrospection [
      gi-docgen
      gobject-introspection
      vala
    ];

  buildInputs = [
    lcms2
  ];

  mesonFlags = [
    (lib.mesonOption "prefix-dev" (placeholder "dev"))
    (lib.mesonBool "with-docs" true)
    (lib.mesonEnable "gi-docgen" withIntrospection)
    (lib.mesonBool "enable-gir" withIntrospection)
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "dependency('vapigen'," "find_program('vapigen', native: true,"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = with lib; {
    description = "Image pixel format conversion library";
    mainProgram = "babl";
    homepage = "https://gegl.org/babl/";
    changelog = "https://gitlab.gnome.org/GNOME/babl/-/blob/BABL_${
      replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }/NEWS";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
})
