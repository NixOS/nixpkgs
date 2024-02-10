{ mkDerivation
, lib
, fetchFromGitHub
, pkg-config
, makeDesktopItem
, qtbase
, qttools
, qtmultimedia
, qtquickcontrols
, openssl
, protobuf
, qmake
}:

mkDerivation rec {
  pname = "ricochet";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "ricochet-im";
    repo = "ricochet";
    rev = "v${version}";
    sha256 = "sha256-CGVTHa0Hqj90WvB6ZbA156DVgzv/R7blsU550y2Ai9c=";
  };

  desktopItem = makeDesktopItem {
    name = "ricochet";
    exec = "ricochet";
    icon = "ricochet";
    desktopName = "Ricochet";
    genericName = "Ricochet";
    comment = meta.description;
    categories = [ "Office" "Email" ];
  };

  buildInputs = [
    qtbase
    qttools
    qtmultimedia
    qtquickcontrols
    openssl
    protobuf
  ];

  nativeBuildInputs = [ pkg-config qmake ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags openssl)"
  '';

  qmakeFlags = [ "DEFINES+=RICOCHET_NO_PORTABLE" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ricochet $out/bin

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications

    mkdir -p $out/share/pixmaps
    cp icons/ricochet.png $out/share/pixmaps/ricochet.png
  '';

  # RCC: Error in 'translation/embedded.qrc': Cannot find file 'ricochet_en.qm'
  enableParallelBuilding = false;

  meta = with lib; {
    description = "Anonymous peer-to-peer instant messaging";
    homepage = "https://ricochet.im";
    license = licenses.bsd3;
    maintainers = [ maintainers.codsl maintainers.jgillich maintainers.np ];
    platforms = platforms.linux;
  };
}
