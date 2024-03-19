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

let
  version = "0.16.3";
  gqlgen = import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion = "0.17.36"; };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "man.sr.ht";
    rev = version;
    hash = "sha256-o1A3LmwH6WgpFqjKyL3UTru9q7TgKdOdbKZfJHR6fCA=";
  };

  mansrht-api = buildGoModule ({
    inherit src version;
    pname = "mansrht-api";
    modRoot = "api";
    vendorHash = "sha256-6AzKWytdyuofCFaDEdeO24mv1mtpnQEJydrjVWGY2eU=";
  } // gqlgen);
in
buildPythonPackage rec {
  inherit src version;
  pname = "mansrht";
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
    maintainers = with maintainers; [ eadwu christoph-heiss ];
  };
}
