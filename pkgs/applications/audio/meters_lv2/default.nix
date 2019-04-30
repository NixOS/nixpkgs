{ stdenv, fetchurl, pkgconfig
, lv2, libGLU_combined, gtk2, cairo, pango, fftwFloat, libjack2 }:

let
  version = "0.9.10";
  name = "meters.lv2-${version}";

  # robtk submodule is pegged to this version
  robtkVersion = "0.6.2";
  robtkName = "robtk-${robtkVersion}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/x42/meters.lv2/archive/v${version}.tar.gz";
    sha256 = "0yfyn7j8g50w671b1z7ph4ppjx8ddj5c6nx53syp5y5mfr1b94nx";
  };

  robtkSrc = fetchurl {
    name = "${robtkName}.tar.gz";
    url = "https://github.com/x42/robtk/archive/v${robtkVersion}.tar.gz";
    sha256 = "1v79xys1k2923wpivdjd44vand6c4agwvnrqi4c8kdv9r07b559v";
  };

in
stdenv.mkDerivation {
  inherit name;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lv2 libGLU_combined gtk2 cairo pango fftwFloat libjack2 ];

  srcs = [ src robtkSrc ];
  sourceRoot = name;

  postUnpack = "mv ${robtkName}/* ${name}/robtk"; # */

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
