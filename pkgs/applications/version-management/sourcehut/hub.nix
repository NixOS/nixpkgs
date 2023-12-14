{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, python
, srht
, setuptools
, pip
, pyyaml
, pythonOlder
, unzip
}:

buildPythonPackage rec {
  pname = "hubsrht";
  version = "0.17.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hub.sr.ht";
    rev = version;
    sha256 = "sha256-A+lvRsPz5EBnM0gB4PJuxSMpELZTrK14ORxDbTKPXWg=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "all: api" ""
  '';

  hubsrht-api = buildGoModule ({
    inherit src version;
    pname = "hubsrht-api";
    modRoot = "api";
    vendorHash = "sha256-K5EmZ4U+xItTR85+SCwhwg5KUGLkKHo9Nr2pkvmJpfo=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  nativeBuildInputs = [
    pip
    setuptools
  ];

  propagatedBuildInputs = [
    srht
    pyyaml
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    ln -s ${hubsrht-api}/bin/api $out/bin/hubsrht-api
  '';


  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "hubsrht"
  ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    description = "Project hub service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
