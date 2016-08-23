{ stdenv, fetchurl, SDL, ftgl, pkgconfig, libpng, libjpeg, pcre
, SDL_image, freetype, glew, mesa, boost, glm
}:

stdenv.mkDerivation rec {
  version = "0.43";
  name = "gource-${version}";

  src = fetchurl {
    url = "https://github.com/acaudwell/Gource/releases/download/${name}/${name}.tar.gz";
    sha256 = "1r5x9ai86f609hf584n0xaf5hxkbilj5qihn89v7ghpmwk40m945";
  };

  buildInputs = [
    glew SDL ftgl pkgconfig libpng libjpeg pcre SDL_image mesa
    boost glm freetype
  ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  NIX_CFLAGS_COMPILE = "-fpermissive " + # fix build with newer gcc versions
                       "-std=c++11"; # fix build with glm >= 0.9.6.0

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/gource/;
    description = "A Software version control visualization tool";
    license = licenses.gpl3Plus;
    longDescription = ''
      Software projects are displayed by Gource as an animated tree with
      the root directory of the project at its centre. Directories
      appear as branches with files as leaves. Developers can be seen
      working on the tree at the times they contributed to the project.

      Currently Gource includes built-in log generation support for Git,
      Mercurial and Bazaar and SVN. Gource can also parse logs produced
      by several third party tools for CVS repositories.
    '';
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
