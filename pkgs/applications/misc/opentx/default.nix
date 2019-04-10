{ stdenv, fetchFromGitHub
, cmake, gcc-arm-embedded, binutils-arm-embedded, python
, qt5, SDL, gtest
, dfu-util, avrdude
}:

let

  version = "2.2.1";

in stdenv.mkDerivation {

  name = "opentx-${version}";

  src = fetchFromGitHub {
    owner = "opentx";
    repo = "opentx";
    rev = version;
    sha256 = "01lnnkrxach21aivnx1k1iqhih02nixh8c4nk6rpw408p13him9g";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    gcc-arm-embedded binutils-arm-embedded
  ];

  buildInputs = with qt5; [
    python python.pkgs.pyqt4
    qtbase qtmultimedia qttranslations
    SDL
  ];

  postPatch = ''
    sed -i companion/src/burnconfigdialog.cpp -e 's|/usr/.*bin/dfu-util|${dfu-util}/bin/dfu-util|'
    sed -i companion/src/burnconfigdialog.cpp -e 's|/usr/.*bin/avrdude|${avrdude}/bin/avrdude|'
  '';

  cmakeFlags = [
    "-DGTEST_ROOT=${gtest.src}/googletest"
    "-DQT_TRANSLATIONS_DIR=${qt5.qttranslations}/translations"
    # XXX I would prefer to include these here, though we will need to file a bug upstream to get that changed.
    #"-DDFU_UTIL_PATH=${dfu-util}/bin/dfu-util"
    #"-DAVRDUDE_PATH=${avrdude}/bin/avrdude"
    "-DNANO=NO"
  ];

  meta = with stdenv.lib; {
    description = "OpenTX Companion transmitter support software";
    longDescription = ''
      OpenTX Companion is used for many different tasks like loading OpenTX
      firmware to the radio, backing up model settings, editing settings and
      running radio simulators.
    '';
    homepage = https://open-tx.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ elitak ];
  };

}
