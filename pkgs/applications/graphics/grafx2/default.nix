{ stdenv, fetchurl, SDL, SDL_image, SDL_ttf, zlib, libpng, pkgconfig, lua5 }:

stdenv.mkDerivation rec {

  version = "2.4.2035";
  name = "grafx2-${version}";

  src = fetchurl {
    url = "https://grafx2.googlecode.com/files/${name}-src.tgz";
    sha256 = "0svsy6rqmdj11b400c242i2ixihyz0hds0dgicqz6g6dcgmcl62q";
  };

  buildInputs = [ SDL SDL_image SDL_ttf libpng zlib lua5 pkgconfig ];

  preBuild = "cd src";

  installPhase = ''
    mkdir -p "$out"
    make install prefix="$out"
  '';

  meta = {
    description = "GrafX2 is a bitmap paint program inspired by the Amiga programs Deluxe Paint and Brilliance.";
    homepage = http://code.google.co/p/grafx2/;
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ stdenv.lib.maintainers.zoomulator ];
  };
}
