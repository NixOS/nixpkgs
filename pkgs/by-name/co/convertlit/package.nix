{lib, stdenv, fetchzip, libtommath}:

stdenv.mkDerivation rec {
  pname = "convertlit";
  version = "1.8";

  src = fetchzip {
    url = "http://www.convertlit.com/convertlit${lib.replaceStrings ["."] [""] version}src.zip";
    sha256 = "182nsin7qscgbw2h92m0zadh3h8q410h5cza6v486yjfvla3dxjx";
    stripRoot = false;
  };

  buildInputs = [libtommath];

  hardeningDisable = [ "format" ];

  buildPhase = ''
    cd lib
    make
    cd ../clit18
    substituteInPlace Makefile \
      --replace ../libtommath-0.30/libtommath.a -ltommath
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp clit $out/bin
  '';

  meta = {
    homepage = "http://www.convertlit.com/";
    description = "Tool for converting Microsoft Reader ebooks to more open formats";
    mainProgram = "clit";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
