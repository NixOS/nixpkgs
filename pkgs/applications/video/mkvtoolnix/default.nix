{ lib
, stdenv
, fetchFromGitLab
, pkg-config
, autoreconfHook
, qmake
, rake
, boost
, cmark
, docbook_xsl
, expat
, file
, flac
, fmt
, gettext
, gmp
, gtest
, libdvdread
, libebml
, libiconv
, libmatroska
, libogg
, libvorbis
, libxslt
, nlohmann_json
, pugixml
, qtbase
, qtmultimedia
, xdg-utils
, zlib
, withGUI ? true
, wrapQtAppsHook
}:

let
  inherit (lib) enableFeature optional optionals optionalString;

  phase = name: args:
    ''
      runHook pre${name}

      rake ${args}

      runHook post${name}
    '';

in
stdenv.mkDerivation rec {
  pname = "mkvtoolnix";
  version = "69.0.0";

  src = fetchFromGitLab {
    owner = "mbunkus";
    repo = "mkvtoolnix";
    rev = "release-${version}";
    sha256 = "sha256-sKm/TjlVFj6Vy6lfy3v7UJoEUXALZZSKO3zoIrYtwrc=";
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
  ++ optional withGUI wrapQtAppsHook;

  # 1. qtbase and qtmultimedia are needed without the GUI
  # 2. we have utf8cpp in nixpkgs but it doesn't find it
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
    qtbase
    qtmultimedia
    xdg-utils
    zlib
  ]
  ++ optional withGUI cmark
  ++ optional stdenv.isDarwin libiconv;

  # autoupdate is not needed but it silences a ton of pointless warnings
  postPatch = ''
    patchShebangs . > /dev/null
    autoupdate configure.ac ac/*.m4
  '';

  configureFlags = [
    "--disable-debug"
    "--disable-precompiled-headers"
    "--disable-profiling"
    "--disable-static-qt"
    "--enable-optimization"
    "--with-boost-libdir=${boost.out}/lib"
    "--with-docbook-xsl-root=${docbook_xsl}/share/xml/docbook-xsl"
    "--with-gettext"
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

  meta = with lib; {
    description = "Cross-platform tools for Matroska";
    homepage = "https://mkvtoolnix.download/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ codyopel rnhmjoj ];
    platforms = platforms.unix;
  };
}
