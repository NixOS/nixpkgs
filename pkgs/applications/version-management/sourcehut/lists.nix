{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, asyncpg
, aiosmtpd
, pygit2
, emailthreads
, redis
, python
}:

buildPythonPackage rec {
  pname = "listssrht";
  version = "0.50.1";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "lists.sr.ht";
    rev = version;
    sha256 = "sha256-FrC3Au/ZdDtJuczGgaAhAEZu0hVa74LOM8z3aOiqGZc=";
  };

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

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
