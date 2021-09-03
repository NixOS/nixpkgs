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
  pname = "tonelib-gfx";
  version = "4.6.6";

  src = fetchurl {
    url = "https://www.tonelib.net/download/0509/ToneLib-GFX-amd64.deb";
    sha256 = "sha256-wdX3SQSr0IZHsTUl+1Y0iETme3gTyryexhZ/9XHkGeo=";
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
    mv $out/bin/ToneLib-GFX $out/bin/tonelib-gfx
  '';

  runtimeDependencies = [
    (lib.getLib curl)
  ];

  meta = with lib; {
    description = "Tonelib GFX is an amp and effects modeling software for electric guitar and bass.";
    homepage = "https://tonelib.net/";
    license = licenses.unfree;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
