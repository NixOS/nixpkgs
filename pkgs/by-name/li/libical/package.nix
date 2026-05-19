{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgsBuildBuild,
  cmake,
  glib,
  icu,
  libxml2,
  ninja,
  perl,
  pkg-config,
  libical,
  python3,
  tzdata,
  fixDarwinDylibNames,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libical";
  version = "3.0.20";

  outputs = [
    "out"
    "dev"
  ]; # "devdoc" ];

  src = fetchFromGitHub {
    owner = "libical";
    repo = "libical";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KIMqZ6QAh+fTcKEYrcLlxgip91CLAwL9rwjUdKzBsQk=";
  };

  strictDeps = true;

  depsBuildBuild = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # provides ical-glib-src-generator that runs during build
    libical
  ];

  nativeBuildInputs = [
    cmake
    icu
    ninja
    perl
    pkg-config
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
    # Docs building fails:
    # https://github.com/NixOS/nixpkgs/pull/67204
    # previously with https://github.com/NixOS/nixpkgs/pull/61657#issuecomment-495579489
    # gtk-doc docbook_xsl docbook_xml_dtd_43 # for docs
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];
  nativeInstallCheckInputs = [
    # running libical-glib tests
    (python3.pythonOnBuildForHost.withPackages (
      pkgs: with pkgs; [
        pygobject3
      ]
    ))
  ];

  buildInputs = [
    glib
    libxml2
    icu
  ];

  cmakeFlags = [
    "-DENABLE_GTK_DOC=False"
    "-DLIBICAL_BUILD_EXAMPLES=False"
    "-DGOBJECT_INTROSPECTION=${if withIntrospection then "True" else "False"}"
    "-DICAL_GLIB_VAPI=${if withIntrospection then "True" else "False"}"
    "-DSTATIC_ONLY=${if stdenv.hostPlatform.isStatic then "True" else "False"}"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DIMPORT_ICAL_GLIB_SRC_GENERATOR=${lib.getDev pkgsBuildBuild.libical}/lib/cmake/LibIcal/IcalGlibSrcGenerator.cmake"
  ];

  patches = [
    # Will appear in 3.1.0
    # https://github.com/libical/libical/issues/350
    ./respect-env-tzdir.patch

    ./static.patch
  ];

  # Using install check so we do not have to manually set GI_TYPELIB_PATH
  # Musl does not support TZDIR.
  doInstallCheck = !stdenv.hostPlatform.isMusl;
  enableParallelChecking = false;
  preInstallCheck =
    if stdenv.hostPlatform.isDarwin then
      ''
        for testexe in $(find ./src/test -maxdepth 1 -type f -executable); do
          for lib in $(cd lib && ls *.3.dylib); do
            install_name_tool -change $lib $out/lib/$lib $testexe
          done
        done
      ''
    else
      null;
  installCheckPhase = ''
    runHook preInstallCheck

    export TZDIR=${tzdata}/share/zoneinfo
    ctest --output-on-failure

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/libical/libical";
    description = "Open Source implementation of the iCalendar protocols";
    changelog = "https://github.com/libical/libical/raw/v${finalAttrs.version}/ReleaseNotes.txt";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
  };
})
