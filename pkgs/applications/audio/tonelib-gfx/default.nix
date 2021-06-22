{ stdenv
, dpkg
, lib
, autoPatchelfHook
, fetchurl
, gtk3
, glib
, desktop-file-utils
, alsaLib
, libjack2
, harfbuzz
, fribidi
, pango
, freetype
}:

stdenv.mkDerivation rec {
  pname = "tonelib-gfx";
  version = "4.6.6";

  src = fetchurl {
    url = "https://www.tonelib.net/download/0509/ToneLib-GFX-amd64.deb";
    sha256 = "sha256-wdX3SQSr0IZHsTUl+1Y0iETme3gTyryexhZ/9XHkGeo=";
  };

  dontUnpack = "true";


  buildInputs = [
    dpkg
    gtk3
    glib
    desktop-file-utils
    alsaLib
    libjack2
    harfbuzz
    fribidi
    pango
    freetype
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    mkdir -p $out/
    dpkg -x $src $out 
    cp $out/usr/* $out/ -r
    mv $out/bin/ToneLib-GFX $out/bin/tonelib-gfx
    rm $out/usr/ -r
  '';

  meta = with lib; {
    description = "Tonelib GFX is an amp and effects modeling software for electric guitar and bass.";
    homepage = "https://tonelib.net/";
    license = licenses.unfree;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
