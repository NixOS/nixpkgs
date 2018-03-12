{ stdenv, fetchurl, pkgconfig
, lv2, libGLU_combined, gtk2, cairo, pango, fftw }:

let
  version = "0.8.1";
  name = "meters.lv2-${version}";

  # robtk submodule is pegged to this version
  robtkVersion = "0.3.0";
  robtkName = "robtk-${robtkVersion}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/x42/meters.lv2/archive/v${version}.tar.gz";
    sha256 = "142dg0j34mv5b0agajj2x1n9kgsmkfh08n1cjzk0j8n4xk2wb6ri";
  };

  robtkSrc = fetchurl {
    name = "${robtkName}.tar.gz";
    url = "https://github.com/x42/robtk/archive/v${robtkVersion}.tar.gz";
    sha256 = "1ny89i2sgga56k7fxskp9y8sb7pfhp6wgw5mni842p19z6q7h8rq";
  };

in
stdenv.mkDerivation {
  inherit name;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lv2 libGLU_combined gtk2 cairo pango fftw ];

  srcs = [ src robtkSrc ];
  sourceRoot = name;

  postUnpack = "mv ${robtkName}/* ${name}/robtk"; # */

  postPatch = "sed -i 's/fftw3f/fftw3/' Makefile";

  preConfigure = "makeFlagsArray=( PREFIX=$out )";
  meter_VERSION = version;

  meta = with stdenv.lib;
    { description = "Collection of audio level meters with GUI in LV2 plugin format";
      homepage = http://x42.github.io/meters.lv2/;
      maintainers = with maintainers; [ ehmry ];
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
}
