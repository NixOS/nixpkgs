{ buildAppImage, fetchurl, stdenv }:

buildAppImage rec {
  pname = "beakerbrowser";
  version = "0.8.8";
  src = fetchurl {
    url = "https://github.com/beakerbrowser/beaker/releases/download/${version}/Beaker.Browser.${version}.AppImage";
    sha256 = "a190f1ca3266b2cb62a76b5a957a3e42b14726ca2732a2797c6fce40aaead695";
  };
  meta = {
    description = "Experimental peer-to-peer Web browser";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ genesis ];
  };
}
