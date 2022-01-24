{ lib, stdenv, fetchFromGitHub, libjack2, gtk2, lv2, faust, pkg-config }:

stdenv.mkDerivation {
  version = "unstable-2015-05-21";
  pname = "foo-yc20";
  src = fetchFromGitHub {
    owner = "sampov2";
    repo = "foo-yc20";
    rev = "edd9d14c91229429b14270a181743e1046160ca8";
    sha256 = "0i8261n95n4xic766h70xkrpbvw3sag96n1883ahmg6h7yb94avq";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libjack2 gtk2 lv2 faust ];

  makeFlags = [ "PREFIX=$(out)" ];

  # remove lv2 until https://github.com/sampov2/foo-yc20/issues/6 is resolved
  postInstallFixup = "rm -rf $out/lib/lv2";

  meta = with lib; {
    broken = true; # see: https://github.com/sampov2/foo-yc20/issues/7
    description = "A Faust implementation of a 1969 designed Yamaha combo organ, the YC-20";
    homepage = "https://github.com/sampov2/foo-yc20";
    license = with licenses; [ bsd3 lgpl21 mpl11 ];
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
