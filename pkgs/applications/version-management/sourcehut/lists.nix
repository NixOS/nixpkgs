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
  version = "0.55.1";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "lists.sr.ht";
    rev = version;
    sha256 = "sha256-gvx5oWsXZitJM4SFjvffF/9mUuylvYrjvsaHsIMQaKM=";
  };

  listssrht-api = buildGoModule ({
    inherit src version;
    pname = "listssrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-gs4JfDOwCnTc54P8L2KGKwhq0HB0v5BOh4UavEN2kh4=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

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
    mkdir -p $out/bin $out/share/sql
    cp schema.sql $out/share/sql/lists-schema.sql
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
