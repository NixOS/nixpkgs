{ stdenv, fetchurl, SDL, SDL_ttf, SDL_image, libSM, libICE, mesa, libpng, lua5, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "gravit-0.5.1";

  src = fetchurl {
    url = "http://gravit.slowchop.com/media/downloads/${name}.tgz";
    sha256 = "14vf7zj2bgrl96wsl3f1knsggc8h9624354ajzd72l46y09x5ky7";
  };

  buildInputs = [ mesa SDL SDL_ttf SDL_image lua5 libpng libSM libICE ];

  nativeBuildInputs = [ autoconf automake ];

  preConfigure = "./autogen.sh";

  meta = {
    homepage = "http://gravit.slowchop.com";
    description = "Beautiful OpenGL-based gravity simulator";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Gravit is a gravity simulator which runs under Linux, Windows and
      Mac OS X. It uses Newtonian physics using the Barnes-Hut N-body
      algorithm. Although the main goal of Gravit is to be as accurate
      as possible, it also creates beautiful looking gravity patterns.
      It records the history of each particle so it can animate and
      display a path of its travels. At any stage you can rotate your
      view in 3D and zoom in and out.
    '';

    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
