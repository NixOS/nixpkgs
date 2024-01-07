{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, pygit2
, python
, unzip
, pip
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "mansrht";
  version = "0.16.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "man.sr.ht";
    rev = version;
    sha256 = "sha256-94G9/Kzt1gaQ2CaXtsJYCB6W5OTdn27XhVdpNJ9a5cE=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "all: api" ""
  '';

  mansrht-api = buildGoModule ({
    inherit src version;
    pname = "mansrht-api";
    modRoot = "api";
    vendorHash = "sha256-K5EmZ4U+xItTR85+SCwhwg5KUGLkKHo9Nr2pkvmJpfo=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  nativeBuildInputs = [
    pip
    setuptools
  ];

  propagatedBuildInputs = [
    srht
    pygit2
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    ln -s ${mansrht-api}/bin/api $out/bin/mansrht-api
  '';

  pythonImportsCheck = [ "mansrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    description = "Wiki service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
