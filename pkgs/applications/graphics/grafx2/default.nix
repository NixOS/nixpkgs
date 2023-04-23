{ lib, stdenv, fetchurl, SDL, SDL_image, SDL_ttf, zlib, libpng, pkg-config, lua5 }:

stdenv.mkDerivation rec {

  version = "2.4.2035";
  pname = "grafx2";

  src = fetchurl {
    url = "https://grafx2.googlecode.com/files/${pname}-${version}-src.tgz";
    sha256 = "0svsy6rqmdj11b400c242i2ixihyz0hds0dgicqz6g6dcgmcl62q";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL SDL_image SDL_ttf libpng zlib lua5 ];

  preBuild = "cd src";

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: ../obj/unix/tiles.o:/build/grafx2/src/global.h:306: multiple definition of
  #     `Main_selector'; ../obj/unix/main.o:/build/grafx2/src/global.h:306: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preInstall = '' mkdir -p "$out" '';

  installPhase = ''make install prefix="$out"'';

  meta = {
    description = "Bitmap paint program inspired by the Amiga programs Deluxe Paint and Brilliance";
    homepage = "http://pulkomandy.tk/projects/GrafX2";
    license = lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [];
  };
}
