{ stdenv, fetchurl, lv2, pkgconfig, mesa, cairo, pango, libjack2 }:

let
  name = "sisco.lv2-${version}";
  version = "0.7.0";

  robtkVersion = "80a2585253a861c81f0bfb7e4579c75f5c73af89";
  robtkName = "robtk-${robtkVersion}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/x42/sisco.lv2/archive/v${version}.tar.gz";
    sha256 = "af7caccf2660138ab4da9b33b2f0e545516e6e49369682e9c7a7b791e1fda0b2";
  };

  robtkSrc = fetchurl {
    name = "${robtkName}.tar.gz";
    url = "https://github.com/x42/robtk/archive/${robtkVersion}.tar.gz";
    sha256 = "81fc907b97705c218670e1fc2642daca6513d11f3d7554a22f8e144877e5c350";
  };
in
stdenv.mkDerivation {
  inherit name;

  srcs = [ src robtkSrc ];
  sourceRoot = name;

  buildInputs = [ pkgconfig lv2 pango cairo libjack2 mesa ];

  postUnpack = "mv ${robtkName}/* ${name}/robtk";
  sisco_VERSION = version;
  preConfigure = "makeFlagsArray=(PREFIX=$out)";

  meta = with stdenv.lib; {
    description = "Simple audio oscilloscope with variable time scale, triggering, cursors and numeric readout in LV2 plugin format";
    homepage = http://x42.github.io/sisco.lv2/;
    license = licenses.gpl2;
    maintainers = [ maintainers.e-user ];
    platforms = platforms.linux;
  };
}
