{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, pyyaml
, python
}:

buildPythonPackage rec {
  pname = "pastesrht";
  version = "0.15.1";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "paste.sr.ht";
    rev = version;
    sha256 = "sha256-IUFX7/V8AWqN+iuisLAyu7lMNIUCzSMoOfcZiYJTnrM=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

  propagatedBuildInputs = [
    srht
    pyyaml
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  pythonImportsCheck = [ "pastesrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/paste.sr.ht";
    description = "Ad-hoc text file hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
