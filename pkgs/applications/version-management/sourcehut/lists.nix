{ stdenv, fetchgit, buildPythonPackage
, python
, srht, asyncpg, aiosmtpd, pygit2, emailthreads }:

buildPythonPackage rec {
  pname = "listssrht";
  version = "0.41.8";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    rev = version;
    sha256 = "Gmt6ttupyhZhpyH/IASEt8SZGrlQmEEtV5bE11yIiXQ=";
  };

  patches = [
    ./use-srht-path.patch
  ];

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pygit2
    asyncpg
    aiosmtpd
    emailthreads
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
