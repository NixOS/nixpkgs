{ stdenv, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-youtube";
  version = "3.0";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-YouTube";
    sha256 = "0x1q9rfnjx65n6hi8s5rw5ff4xv55h63zy52fwm8aksdnzppr7gd";
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
