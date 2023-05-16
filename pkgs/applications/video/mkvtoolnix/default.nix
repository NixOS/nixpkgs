{ lib
, stdenv
, fetchFromGitLab
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, autoreconfHook
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
<<<<<<< HEAD
  version = "78.0";
=======
  version = "75.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "mbunkus";
    repo = "mkvtoolnix";
    rev = "release-${version}";
<<<<<<< HEAD
    sha256 = "sha256-iImcpuGZsRlwBTPyPUsfHAOkOIhc8eYs6rinl8O78oU=";
=======
    sha256 = "c3I2ULSvKBTYIm1chVHPkaV0TxblLglBjzeUJ5TRmGw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    "--disable-update-check"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--enable-optimization"
    "--with-boost-libdir=${lib.getLib boost}/lib"
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
    mainProgram = if withGUI then "mkvtoolnix-gui" else "mkvtoolnix";
    maintainers = with maintainers; [ codyopel rnhmjoj ];
    platforms = platforms.unix;
  };
}
