{ stdenv, graphicsmagick }:

stdenv.mkDerivation rec {
  pname = "graphicsmagick-imagemagick-compat";
  inherit (graphicsmagick) version;

  dontUnpack = true;
  buildPhase = "true";

  utils = [
    "composite"
    "conjure"
    "convert"
    "identify"
    "mogrify"
    "montage"
    "animate"
    "display"
    "import"
  ];

  # TODO: symlink libraries?
  installPhase = ''
    mkdir -p "$out"/bin
    mkdir -p "$out"/share/man/man1
    for util in ''${utils[@]}; do
      ln -s ${graphicsmagick}/bin/gm "$out/bin/$util"
      ln -s ${graphicsmagick}/share/man/man1/gm.1.gz "$out/share/man/man1/$util.1.gz"
    done
  '';

  meta = {
    description = "ImageMagick interface for GraphicsMagick";
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.all;
  };
}
