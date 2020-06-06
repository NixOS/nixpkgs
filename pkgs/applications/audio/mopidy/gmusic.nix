{ stdenv, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-gmusic";
  version = "4.0.0";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-GMusic";
    sha256 = "14yswmlfs659rs3k595606m77lw9c6pjykb5pikqw21sb97haxl3";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.requests
    python3Packages.gmusicapi
    python3Packages.cachetools
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for playing music from Google Play Music";
    license = licenses.asl20;
    maintainers = [ maintainers.jgillich ];
    hydraPlatforms = [];
  };
}
