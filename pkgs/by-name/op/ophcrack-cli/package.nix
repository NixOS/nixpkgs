{ lib
, stdenvNoCC
, libsForQt5
, fetchurl
, fetchpatch
, autoreconfHook
, libtool
, pkg-config
, zlib
, openssl
, freetype
, gcc
}:

stdenvNoCC.mkDerivation rec {
  pname = "ophcrack";
  version = "3.8.0";

  src = fetchurl {
    url = "https://sourceforge.net/projects/ophcrack/files/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2";
    hash = "sha256-BIpt9XmDo6WjGsfE7BLfFqpJ5lKilnbZPU75WdUK7uA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    pkg-config
    zlib
    openssl
    freetype
    gcc
    libsForQt5.qtcharts
  ];

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/ophcrack/-/raw/c60118b40802e1162dcebfe5f881cf973b2334d3/debian/patches/fix_spelling_error.diff";
      hash = "sha256-Fc044hTU4Mtdym+HukGAwGzaLm7aVzV9KpvHvFUG2Sc=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/ophcrack/-/raw/e19d993a7dbf131d13128366e2aac270a685befc/debian/patches/qmake_crossbuild.diff";
      hash = "sha256-sOKXOBpAYGLacU6IxjRzy3HCnGm4DFowDL2qP+DzG8M=";
    })
  ];

  dontWrapQtApps = true;

  configureFlags = [
    "--with-libssl=yes"
    "--disable-gui"
  ];

  buildPhase = ''
    make
  '';

  postInstall = ''
    mv $out/bin/ophcrack $out/bin/ophcrack-cli
  '';

  meta = with lib; {
    description = "Password crack based on the faster time-memory trade-off. With MySQL and Cisco PIX Algorithm patches";
    homepage = "https://ophcrack.sourceforge.io";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "ophcrack-cli";
    platforms = platforms.all;
  };
}

