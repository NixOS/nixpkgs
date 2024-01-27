{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, alembic
, pytest
, factory-boy
, python
, unzip
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "todosrht";
  version = "0.74.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "todo.sr.ht";
    rev = version;
    sha256 = "sha256-j12pCGfKf6+9R8NOBIrH2V4OuSMuncU6S1AMWFVoHts=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

  todosrht-api = buildGoModule ({
    inherit src version;
    pname = "todosrht-api";
    modRoot = "api";
    vendorHash = "sha256-rvfG5F6ez8UM0dYVhKfzwtb7ZEJlaKMBAfKDbo3Aofc=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    srht
    alembic
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    ln -s ${todosrht-api}/bin/api $out/bin/todosrht-api
  '';

  # pytest tests fail
  nativeCheckInputs = [
    pytest
    factory-boy
  ];

  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "todosrht" ];

  meta = with lib; {
    homepage = "https://todo.sr.ht/~sircmpwn/todo.sr.ht";
    description = "Ticket tracking service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
