{ lib, stdenv, fetchFromGitHub, lv2, pkg-config, libGLU, libGL, cairo, pango, libjack2 }:

let
  version = "0.7.0";

  robtkVersion = "80a2585253a861c81f0bfb7e4579c75f5c73af89";
  robtkName = "robtk-${robtkVersion}";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "sisco.lv2";
    rev = "v${version}";
    sha256 = "1r6g29yqbdqgkh01x6d3nvmvc58rk2dp94fd0qyyizq37a1qplj1";
  };

  robtkSrc = fetchFromGitHub {
    owner = "x42";
    repo = "robtk";
    rev = robtkVersion;
    sha256 = "0gk16nrvnrffqqw0yd015kja9wkgbzvb648bl1pagriabhznhfxl";
  };
in
stdenv.mkDerivation rec {
  pname = "sisco.lv2";
  inherit version;

  srcs = [ src robtkSrc ];
  sourceRoot = src.name;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ lv2 pango cairo libjack2 libGLU libGL ];

  postUnpack = "chmod u+w -R ${robtkName}-src; mv ${robtkName}-src/* ${sourceRoot}/robtk";
  sisco_VERSION = version;
  preConfigure = "makeFlagsArray=(PREFIX=$out)";

  meta = with lib; {
    description = "Simple audio oscilloscope with variable time scale, triggering, cursors and numeric readout in LV2 plugin format";
    homepage = "http://x42.github.io/sisco.lv2/";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
