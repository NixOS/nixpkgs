{ stdenv, fetchurl, SDL2, ftgl, pkgconfig, libpng, libjpeg, pcre
, SDL2_image, freetype, glew, libGLU_combined, boost, glm
}:

stdenv.mkDerivation rec {
  version = "0.49";
  name = "gource-${version}";

  src = fetchurl {
    url = "https://github.com/acaudwell/Gource/releases/download/${name}/${name}.tar.gz";
    sha256 = "12hf5ipcsp9dxsqn84n4kr63xaiskrnf5a084wr29qk171lj7pd9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    glew SDL2 ftgl libpng libjpeg pcre SDL2_image libGLU_combined
    boost glm freetype
  ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://gource.io/;
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
