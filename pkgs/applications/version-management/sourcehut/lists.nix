{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, asyncpg
, aiosmtpd
, pygit2
, emailthreads
, redis
, python
, unzip
}:

buildPythonPackage rec {
  pname = "listssrht";
  version = "0.51.9";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "lists.sr.ht";
    rev = version;
    sha256 = "sha256-6iyt0XXAHvyp4bA+VW9uA9YP9wq2Rf/WYVZxylSRf7k=";
  };

  listssrht-api = buildGoModule ({
    inherit src version;
    pname = "listssrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-xnmMkRSokbhWD+kz0XQ9AinYdm6/50FRBISURPvlzD0=";
  } // import ./fix-gqlgen-trimpath.nix {inherit unzip;});

  patches = [
    # Revert change breaking Unix socket support for Redis
    patches/redis-socket/lists/0001-Revert-Add-webhook-queue-monitoring.patch
  ];
  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pygit2
    asyncpg
    aiosmtpd
    emailthreads
    redis
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    ln -s ${listssrht-api}/bin/api $out/bin/listssrht-api
  '';

  pythonImportsCheck = [ "listssrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
