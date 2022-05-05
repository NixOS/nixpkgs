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
  version = "0.71.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "todo.sr.ht";
    rev = version;
    sha256 = "sha256-IIZKN006UIrdcxF+LYkUtc97QoCnWqzX8036vMctWHY=";
  };

  patches = [
    # Revert change breaking Unix socket support for Redis
    patches/redis-socket/todo/0001-Revert-Add-webhook-queue-monitoring.patch
  ];
  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';


  todosrht-api = buildGoModule ({
    inherit src version;
    pname = "todosrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-ttGT7lUh8O+9KvbaEGWUsthefXQ2ATeli0tnlXCjZFk=";
  } // import ./fix-gqlgen-trimpath.nix {inherit unzip;});

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

  postInstall = ''
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
