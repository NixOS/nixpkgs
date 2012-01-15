{stdenv, fetchurl, SDL, ftgl, pkgconfig, libpng, libjpeg, pcre, SDL_image, glew, mesa}:

let
  name = "gource-0.37";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://gource.googlecode.com/files/${name}.tar.gz";
    sha256 = "03kd9nn65cl1p2jgn6pvpxmvnfscz3c8jqds90fsc0z37ij2iiyn";
  };

  buildInputs = [glew SDL ftgl pkgconfig libpng libjpeg pcre SDL_image mesa];

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

    platforms = stdenv.lib.platforms.gnu;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
