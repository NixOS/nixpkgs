{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, redis
, alembic
, pystache
, pytest
, factory_boy
, python
, unzip
}:

buildPythonPackage rec {
  pname = "todosrht";
  version = "0.74.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "todo.sr.ht";
    rev = version;
    sha256 = "sha256-/5ztB7FWWN9r0JkaNnSseJ8v/keLdRYIts8HpvX8i58=";
  };

  patches = [ ./patches/todosrht/0001-schema-fix-typo.patch ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

  todosrht-api = buildGoModule ({
    inherit src version;
    pname = "todosrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-rvfG5F6ez8UM0dYVhKfzwtb7ZEJlaKMBAfKDbo3Aofc=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

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

  postInstall = ''
    mkdir -p $out/bin $out/share/sql
    cp schema.sql $out/share/sql/todo-schema.sql
    ln -s ${todosrht-api}/bin/api $out/bin/todosrht-api
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
