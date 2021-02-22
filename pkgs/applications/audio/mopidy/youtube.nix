{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-youtube";
  version = "3.2";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-YouTube";
    sha256 = "0wmalfqnskglssq3gj6kkrq6h6c9yab503y72afhkm7n9r5c57zz";
  };

  patchPhase = "sed s/bs4/beautifulsoup4/ -i setup.cfg";

  propagatedBuildInputs = [
    mopidy
    python3Packages.beautifulsoup4
    python3Packages.cachetools
    python3Packages.youtube-dl
  ];

  doCheck = false;

  meta = with lib; {
    description = "Mopidy extension for playing music from YouTube";
    license = licenses.asl20;
    maintainers = [ maintainers.spwhitt ];
  };
}
