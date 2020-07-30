{ stdenv, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-youtube";
  version = "3.1";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-YouTube";
    sha256 = "1bn3nxianbal9f81z9wf2cxi893hndvrz2zdqvh1zpxrhs0cr038";
  };

  patchPhase = "sed s/bs4/beautifulsoup4/ -i setup.cfg";

  propagatedBuildInputs = [
    mopidy
    python3Packages.beautifulsoup4
    python3Packages.cachetools
    python3Packages.youtube-dl
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from YouTube";
    license = licenses.asl20;
    maintainers = [ maintainers.spwhitt ];
  };
}
