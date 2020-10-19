{ lib
, mopidy
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Local";
  version = "3.1.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "13m0iz14lyplnpm96gfpisqvv4n89ls30kmkg21z7v238lm0h19j";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.uritools
  ];

  checkInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-local";
    description = "Mopidy extension for playing music from your local music archive";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
