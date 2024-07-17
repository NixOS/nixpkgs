{
  lib,
  stdenv,
  fetchurl,
  unzip,
  puredata,
  fftw,
}:

stdenv.mkDerivation rec {
  version = "0.7.0";
  pname = "timbreid";

  src = fetchurl {
    url = "http://williambrent.conflations.com/pd/timbreID-${version}-src.zip";
    sha256 = "14k2xk5zrzrw1zprdbwx45hrlc7ck8vq4drpd3l455i5r8yk4y6b";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    puredata
    fftw
  ];

  unpackPhase = ''
    mkdir source
    cd source
    unzip $src
  '';

  buildPhase = ''
    make tIDLib.o all
  '';

  installPhase = ''
    mkdir -p $out/
    cp -r *.pd $out/
    cp -r *.pd_linux $out/
    cp -r audio/ $out/
    cp -r data/ $out/
    cp -r doc/ $out/
  '';

  postFixup = ''
    mv $out/share/doc/ $out/
    rm -rf $out/share/
  '';

  meta = {
    description = "A collection of audio feature analysis externals for puredata";
    homepage = "http://williambrent.conflations.com/pages/research.html";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
