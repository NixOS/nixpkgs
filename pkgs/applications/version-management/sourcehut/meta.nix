{ stdenv, fetchgit, buildPythonPackage
, python
, pgpy, srht, redis, bcrypt, qrcode, stripe, zxcvbn, alembic, pystache
, sshpubkeys, weasyprint }:

buildPythonPackage rec {
  pname = "metasrht";
  version = "0.42.13";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    rev = version;
    sha256 = "0bnrhk4w35w9dndihfqki66vyk123my98p4jqic4ypxcyffs1dd7";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    pgpy
    srht
    redis
    bcrypt
    qrcode
    stripe
    zxcvbn
    alembic
    pystache
    sshpubkeys
    weasyprint
  ];

  patches = [
    ./use-srht-path.patch
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    description = "Account management service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
