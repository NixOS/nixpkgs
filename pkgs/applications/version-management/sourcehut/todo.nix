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
  version = "0.65.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "todo.sr.ht";
    rev = version;
    sha256 = "sha256-46RkBwLuGpYYw2V4JBDR414W2EaYnz0rru/T9j/PrJs=";
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
  pythonImportsCheck = [ "todosrht" ];

  meta = with lib; {
    homepage = "https://todo.sr.ht/~sircmpwn/todo.sr.ht";
    description = "Ticket tracking service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
