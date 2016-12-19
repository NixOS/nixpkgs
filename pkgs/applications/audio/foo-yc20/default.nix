{ stdenv, fetchFromGitHub,  libjack2, gtk2, lv2, faust, pkgconfig }:

stdenv.mkDerivation rec {
  version = "git-2015-05-21";
  name = "foo-yc20-${version}";
  src = fetchFromGitHub {
    owner = "sampov2";
    repo = "foo-yc20";
    rev = "edd9d14c91229429b14270a181743e1046160ca8";
    sha256 = "0i8261n95n4xic766h70xkrpbvw3sag96n1883ahmg6h7yb94avq";
  };

  buildInputs = [ libjack2 gtk2 lv2 faust pkgconfig ];

  makeFlags = "PREFIX=$(out)";

  # remove lv2 until https://github.com/sampov2/foo-yc20/issues/6 is resolved
  postInstallFixup = "rm -rf $out/lib/lv2";

  meta = {
    broken = true; # see: https://github.com/sampov2/foo-yc20/issues/7
    description = "A Faust implementation of a 1969 designed Yamaha combo organ, the YC-20";
    homepage = https://github.com/sampov2/foo-yc20;
    license     = "BSD";
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
