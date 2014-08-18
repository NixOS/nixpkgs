{ stdenv, fetchurl, SDL, SDL_ttf, SDL_image, mesa, libpng, lua5, automake, autoconf }:

stdenv.mkDerivation rec {
  name = "gravit-0.5.0";

  src = fetchurl {
    url = "http://gravit.slowchop.com/media/downloads/${name}.tgz";
    sha256 = "0lyw0skrkb04s16vgz7ggswjrdxk1h23v5s85s09gjxzjp1xd3xp";
  };

  buildInputs = [mesa SDL SDL_ttf SDL_image lua5 automake autoconf libpng];

  preConfigure = "sh autogen.sh";

  meta = {
    homepage = "http://gravit.slowchop.com";
    description = "A beautiful OpenGL-based gravity simulator";
    license = "GPLv2";

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
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
