{ stdenv, fetchurl, python2Packages, mopidy }:

python2Packages.buildPythonApplication rec {
  pname = "mopidy-gmusic";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-gmusic/archive/v${version}.tar.gz";
    sha256 = "0a2s4xrrhnkv85rx4w5bj6ih9xm34jy0q71fdvbzmi827g9dw5sz";
  };

  propagatedBuildInputs = [
    mopidy
    python2Packages.requests
    python2Packages.gmusicapi
    python2Packages.cachetools
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://www.mopidy.com/;
    description = "Mopidy extension for playing music from Google Play Music";
    license = licenses.asl20;
    maintainers = [ maintainers.jgillich ];
    hydraPlatforms = [];
  };
}
