{ lib
, stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, libtool
, zlib
, pkg-config
, openssl
, freetype
, expat
}:

stdenv.mkDerivation rec {
  pname = "ophcrack";
  version = "3.8.0";

  src = fetchurl {
    url = "https://sourceforge.net/projects/ophcrack/files/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2";
    hash = "sha256-BIpt9XmDo6WjGsfE7BLfFqpJ5lKilnbZPU75WdUK7uA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    expat
  ];

  buildInputs = [
    zlib
    openssl
    freetype
    pkg-config
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

  configureFlags = [
    "--with-libssl=yes"
    "--disable-gui"
  ];

  buildPhase = ''
    runHook preBuild

    make

    runHook postBuild
  '';

  postInstall = ''
    mv $out/bin/ophcrack $out/bin/ophcrack-cli
  '';

  meta = with lib; {
    description = "Free Windows password cracker based on rainbow tables";
    homepage = "https://ophcrack.sourceforge.io";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "ophcrack-cli";
    platforms = platforms.all;
  };
}

