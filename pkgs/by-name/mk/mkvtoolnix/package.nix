{
  lib,
  stdenv,
  fetchFromGitea,
  pkg-config,
  autoreconfHook,
  rake,
  boost,
  cmark,
  docbook_xsl,
  expat,
  file,
  flac,
  fmt,
  gettext,
  gmp,
  gtest,
  libdvdread,
  libebml,
  libiconv,
  libmatroska,
  libogg,
  libvorbis,
  libxslt,
  nlohmann_json,
  pugixml,
  qt6,
  utf8cpp,
  xdg-utils,
  zlib,
  nix-update-script,
  withGUI ? true,
}:

let
  inherit (lib)
    enableFeature
    getDev
    getLib
    optionals
    optionalString
    ;

  phase = name: args: ''
    runHook pre${name}

    rake ${args}

    runHook post${name}
  '';

in
stdenv.mkDerivation (finalAttrs: {
  pname = "mkvtoolnix";
  version = "96.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mbunkus";
    repo = "mkvtoolnix";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-0jypoZK6lTWAQwcuOVH3EWtA9B01bVIay4HNgEDJIRI=";
  };

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=release-(.*)" ];
    };
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook_xsl
    gettext
    gtest
    libxslt
    pkg-config
    rake
  ]
  ++ optionals withGUI [ qt6.wrapQtAppsHook ];

  # qtbase and qtmultimedia are needed without the GUI
  buildInputs = [
    boost
    expat
    file
    flac
    fmt
    gmp
    libdvdread
    libebml
    libmatroska
    libogg
    libvorbis
    nlohmann_json
    pugixml
    qt6.qtbase
    qt6.qtmultimedia
    utf8cpp
    xdg-utils
    zlib
  ]
  ++ optionals withGUI [ cmark ]
  ++ optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ];

  # autoupdate is not needed but it silences a ton of pointless warnings
  postPatch = ''
    patchShebangs . > /dev/null
    autoupdate configure.ac ac/*.m4
  '';

  configureFlags = [
    "--disable-debug"
    "--disable-precompiled-headers"
    "--disable-profiling"
    "--disable-update-check"
    "--enable-optimization"
    "--with-boost-libdir=${getLib boost}/lib"
    "--with-docbook-xsl-root=${docbook_xsl}/share/xml/docbook-xsl"
    "--with-gettext"
    "--with-extra-includes=${getDev utf8cpp}/include/utf8cpp"
    "--with-extra-libs=${getLib utf8cpp}/lib"
    (enableFeature withGUI "gui")
  ];

  buildPhase = phase "Build" "";

  installPhase = phase "Install" "install";

  doCheck = true;

  checkPhase = phase "Check" "tests:run_unit";

  dontWrapQtApps = true;

  postFixup = optionalString withGUI ''
    wrapQtApp $out/bin/mkvtoolnix-gui
  '';

  meta = {
    description = "Cross-platform tools for Matroska";
    homepage = "https://mkvtoolnix.download/";
    license = lib.licenses.gpl2Only;
    mainProgram = if withGUI then "mkvtoolnix-gui" else "mkvtoolnix";
    maintainers = with lib.maintainers; [
      codyopel
      rnhmjoj
    ];
    platforms = lib.platforms.unix;
  };
})
