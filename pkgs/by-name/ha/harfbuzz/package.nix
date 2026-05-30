{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  freetype,
  libintl,
  meson,
  ninja,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  withRaster ? false,
  withCairo ? false,
  cairo,
  icu,
  graphite2,
  harfbuzz, # The icu variant uses and propagates the non-icu one.
  withCoreText ? stdenv.hostPlatform.isDarwin, # withCoreText is required for macOS
  withIcu ? false, # recommended by upstream as default, but most don't needed and it's big
  withGraphite2 ? true, # it is small and major distros do include it
  python3,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  # for passthru.tests
  gimp,
  gtk3,
  gtk4,
  mapnik,
  qt5,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "harfbuzz${lib.optionalString withIcu "-icu"}";
  version = "13.2.1";

  src = fetchurl {
    url = "https://github.com/harfbuzz/harfbuzz/releases/download/${finalAttrs.version}/harfbuzz-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZpXaPrfhvgqjCS/k2BQzoztH9FGSWcdZ1ynjqaVcFCk=";
  };

  # This test fails reliably when executed through mesonCheckPhase but passes with
  # a direct 'meson test' checkPhase, the validated symbols are fine but msan is not happy
  # skipping this for now as it is not relevant for the packaging
  patches = [ ./disable-check-symbols-test.patch ];

  postPatch = ''
    patchShebangs src/*.py test
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # ApplicationServices.framework headers have cast-align warnings.
    substituteInPlace src/hb.hh \
      --replace-fail '#pragma GCC diagnostic error   "-Wcast-align"' ""
  '';

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev";

  mesonFlags = [
    # upstream recommends cairo, but it is only used for development purposes
    # and hb-raster and is not part of the main library.
    # Cairo causes transitive (build) dependencies on various X11 or other
    # GUI-related libraries, so it shouldn't be re-added lightly.
    (lib.mesonEnable "cairo" withCairo)
    (lib.mesonEnable "raster" withRaster)
    # chafa is only used in a development utility, not in the library
    (lib.mesonEnable "chafa" false)
    (lib.mesonEnable "coretext" withCoreText)
    (lib.mesonEnable "graphite" withGraphite2)
    (lib.mesonEnable "icu" withIcu)
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonOption "cmakepackagedir" "${placeholder "dev"}/lib/cmake")
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    libintl
    pkg-config
    python3
    glib
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ]
  ++ lib.optional withIntrospection gobject-introspection
  ++ lib.optional withCairo cairo;

  buildInputs = [
    glib
    freetype
  ];

  propagatedBuildInputs =
    lib.optional withGraphite2 graphite2
    ++ lib.optionals withIcu [
      icu
      harfbuzz
    ];

  doCheck = true;

  # test_native_coretext_variations depends on the system fonts.
  __impureHostDeps = lib.optionals stdenv.hostPlatform.isDarwin [
    "/System/Library/Fonts"
  ];

  # Slightly hacky; some pkgs expect them in a single directory.
  postFixup = lib.optionalString withIcu ''
    rm "$out"/lib/libharfbuzz.* "$dev/lib/pkgconfig/harfbuzz.pc"
    ln -s {'${harfbuzz.dev}',"$dev"}/lib/pkgconfig/harfbuzz.pc
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      ln -s {'${harfbuzz.out}',"$out"}/lib/libharfbuzz.dylib
      ln -s {'${harfbuzz.out}',"$out"}/lib/libharfbuzz.0.dylib
    ''}
  '';

  passthru.tests = {
    inherit
      gimp
      gtk3
      gtk4
      mapnik
      ;
    inherit (qt5) qtbase;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "OpenType text shaping engine";
    homepage = "https://harfbuzz.github.io/";
    changelog = "https://github.com/harfbuzz/harfbuzz/raw/${finalAttrs.version}/NEWS";
    maintainers = [ lib.maintainers.cobalt ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [
      "harfbuzz"
      "harfbuzz-gobject"
      "harfbuzz-subset"
      "harfbuzz-vector"
    ]
    ++ (lib.optional withIcu "harfbuzz-icu")
    ++ (lib.optional withRaster "harfbuzz-raster")
    ++ (lib.optional withCairo "harfbuzz-cairo");
  };
})
