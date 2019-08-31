{ stdenv, fetchgit, buildPythonPackage
, python
, srht, asyncpg, unidiff, aiosmtpd, emailthreads }:

buildPythonPackage rec {
  pname = "listssrht";
  version = "0.36.3";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    rev = version;
    sha256 = "1q2z2pjwz4zifsrkxab9b9jh1vzayjqych1cx3i4859f1swl2gwa";
  };

  patches = [
    ./use-srht-path.patch
  ];

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    asyncpg
    unidiff
    aiosmtpd
    emailthreads
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/lists.sr.ht;
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
