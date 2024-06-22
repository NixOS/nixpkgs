{ lib
, stdenv
, enableQt5 ? true
, libsForQt5
, fetchurl
, fetchpatch
, enableGui ? true
, autoreconfHook
, pkg-config
, openssl
}:

stdenv.mkDerivation rec {
  pname = "ophcrack";
  version = "3.8.0";

  src = fetchurl {
    url = "https://sourceforge.net/projects/ophcrack/files/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2";
    hash = "sha256-BIpt9XmDo6WjGsfE7BLfFqpJ5lKilnbZPU75WdUK7uA=";
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals enableGui [
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals enableQt5 [
    libsForQt5.qtcharts
  ];

  dontWrapQtApps = true;

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
    "--enable-gui=${if enableGui then "yes" else "no"}"
    "--with-qt5charts=${if enableQt5 then "yes" else "no"}"
  ];

  postInstall = ''
    wrapProgram $out/bin/ophcrack \
      --prefix PATH : "${libsForQt5.qtbase}/bin"
  '';

  meta = with lib; {
    description = "Password crack based on the faster time-memory trade-off. With MySQL and Cisco PIX Algorithm patches";
    homepage = "https://ophcrack.sourceforge.io";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "ophcrack";
    platforms = platforms.all;
  };
}
