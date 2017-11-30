{ stdenv, fetchurl, SDL2, ftgl, pkgconfig, libpng, libjpeg, pcre
, SDL2_image, freetype, glew, mesa, boost, glm
}:

stdenv.mkDerivation rec {
  version = "0.47";
  name = "gource-${version}";

  src = fetchurl {
    url = "https://github.com/acaudwell/Gource/releases/download/${name}/${name}.tar.gz";
    sha256 = "1llqwdnfa1pff8bxk27qsqff1fcg0a9kfdib0rn7p28vl21n1cgj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    glew SDL2 ftgl libpng libjpeg pcre SDL2_image mesa
    boost glm freetype
  ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://gource.io/;
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
