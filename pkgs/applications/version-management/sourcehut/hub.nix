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

let
  version = "0.17.7";
  gqlgen = import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion = "0.17.43"; };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hub.sr.ht";
    rev = version;
    hash = "sha256-IyY7Niy/vZSAXjYZMlxY6uuQ8nH/4yT4+MaRjHtl6G4=";
  };

  hubsrht-api = buildGoModule ({
    inherit src version;
    pname = "hubsrht-api";
    modRoot = "api";
    vendorHash = "sha256-GVN11nEJqIHh8MtKvIXe4zcUwJph9eTSkJ2R+ufD+ic=";
  } // gqlgen);
in
buildPythonPackage rec {
  inherit src version;
  pname = "hubsrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  postPatch = ''
    substituteInPlace Makefile --replace "all: api" ""
  '';

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
    maintainers = with maintainers; [ eadwu christoph-heiss ];
  };
}
