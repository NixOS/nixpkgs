{ stdenv
, lib
, mopidy
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Local";
  version = "3.2.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "18w39mxpv8p17whd6zfw5653d21q138f8xd6ili6ks2g2dbm25i9";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.uritools
  ];

  checkInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/mopidy/mopidy-local";
    description = "Mopidy extension for playing music from your local music archive";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
