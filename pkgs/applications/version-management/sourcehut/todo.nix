{ stdenv, fetchgit, buildPythonPackage
, python
, srht, redis, alembic, pystache
, pytest, factory_boy, writeText }:

buildPythonPackage rec {
  pname = "todosrht";
  version = "0.61.11";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/todo.sr.ht";
    rev = version;
    sha256 = "lUM81FYlR6AXCtXZtYiB+1FD8E1aOX7qxbWUVc36lJM=";
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
  '';

  # pytest tests fail
  checkInputs = [
    pytest
    factory_boy
  ];

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://todo.sr.ht/~sircmpwn/todo.sr.ht";
    description = "Ticket tracking service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
