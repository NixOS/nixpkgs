{ lib, stdenv, fetchurl, SDL2, ftgl, pkg-config, libpng, libjpeg, pcre
, SDL2_image, freetype, glew, libGLU, libGL, boost, glm
}:

stdenv.mkDerivation rec {
  version = "0.51";
  pname = "gource";

  src = fetchurl {
    url = "https://github.com/acaudwell/Gource/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "16p7b1x4r0915w883lp374jcdqqja37fnb7m8vnsfnl2n64gi8qr";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glew SDL2 ftgl libpng libjpeg pcre SDL2_image libGLU libGL
    boost glm freetype
  ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://gource.io/";
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
