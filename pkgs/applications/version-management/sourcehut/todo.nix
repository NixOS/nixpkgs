{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, redis
, alembic
, pystache
, pytest
, factory_boy
, python
}:

buildPythonPackage rec {
  pname = "todosrht";
  version = "0.64.14";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "todo.sr.ht";
    rev = version;
    sha256 = "sha256-huIAhn6h1F5w5ST4/yBwr82kAzyYwhLu+gpRuOQgnsE=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    redis
    alembic
    pystache
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  # pytest tests fail
  checkInputs = [
    pytest
    factory_boy
  ];

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://todo.sr.ht/~sircmpwn/todo.sr.ht";
    description = "Ticket tracking service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
