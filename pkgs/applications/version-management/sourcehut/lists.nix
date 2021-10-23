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
  version = "0.50.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "lists.sr.ht";
    rev = version;
    sha256 = "sha256-2NO6WJCOwCqGuICnn425NbnemTm8vYBltJyrveUt1n0=";
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

  pythonImportsCheck = [ "listssrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
