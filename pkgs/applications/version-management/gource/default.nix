{ stdenv, fetchurl, SDL, ftgl, pkgconfig, libpng, libjpeg, pcre
, SDL_image, glew, mesa, boost, glm
}:

stdenv.mkDerivation rec {
  version = "0.42";
  name = "gource-${version}";

  src = fetchurl {
    url = "https://github.com/acaudwell/Gource/releases/download/${name}/${name}.tar.gz";
    sha256 = "08ab57z44y8b5wxg1193j6hiy50njbpi6dwafjh6nb0apcq8ziz5";
  };

  buildInputs = [
    glew SDL ftgl pkgconfig libpng libjpeg pcre SDL_image mesa
    boost glm
  ];

  configureFlags = [ "--with-boost-libdir=${boost.lib}/lib" ];

  NIX_CFLAGS_COMPILE = "-fpermissive"; # fix build with newer gcc versions

  meta = {
    homepage = "http://code.google.com/p/gource/";
    description = "software version control visualization tool";
    license = stdenv.lib.licenses.gpl3Plus;
    longDescription = ''
      Software projects are displayed by Gource as an animated tree with
      the root directory of the project at its centre. Directories
      appear as branches with files as leaves. Developers can be seen
      working on the tree at the times they contributed to the project.

      Currently Gource includes built-in log generation support for Git,
      Mercurial and Bazaar and SVN. Gource can also parse logs produced
      by several third party tools for CVS repositories.
    '';
    platforms = stdenv.lib.platforms.linux;
  };
}
