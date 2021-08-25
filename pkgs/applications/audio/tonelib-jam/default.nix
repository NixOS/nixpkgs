{ stdenv
, dpkg
, lib
, autoPatchelfHook
, fetchurl
, gtk3
, glib
, desktop-file-utils
, alsa-lib
, libjack2
, harfbuzz
, fribidi
, pango
, freetype
, curl
}:

stdenv.mkDerivation rec {
  pname = "tonelib-jam";
  version = "4.6.6";

  src = fetchurl {
    url = "https://www.tonelib.net/download/0509/ToneLib-Jam-amd64.deb";
    sha256 = "sha256-cizIQgO35CQSLme/LKQqP+WzB/jCTk+fS5Z+EtF7wnQ=";
  };

  buildInputs = [
    dpkg
    gtk3
    glib
    desktop-file-utils
    alsa-lib
    libjack2
    harfbuzz
    fribidi
    pango
    freetype
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  unpackPhase = ''
    mkdir -p $TMP/ $out/
    dpkg -x $src $TMP
  '';

  installPhase = ''
    cp -R $TMP/usr/* $out/
    mv $out/bin/ToneLib-Jam $out/bin/tonelib-jam
  '';

  runtimeDependencies = [
    (lib.getLib curl)
  ];

  meta = with lib; {
    description = "ToneLib Jam – the learning and practice software for guitar players";
    homepage = "https://tonelib.net/";
    license = licenses.unfree;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
