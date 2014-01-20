{ stdenv, fetchurl, SDL, ftgl, pkgconfig, libpng, libjpeg, pcre
, SDL_image, glew, mesa, boost, glm
}:

stdenv.mkDerivation rec {
  name = "gource-0.40";

  src = fetchurl {
    url = "http://gource.googlecode.com/files/${name}.tar.gz";
    sha256 = "04nirh07xjslqsph557as4s50nlf91bi6v2l7vmbifmkdf90m2cw";
  };

  buildInputs = [
    glew SDL ftgl pkgconfig libpng libjpeg pcre SDL_image mesa boost glm
  ];

  configureFlags = "--with-boost-libdir=${boost}/lib";

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
