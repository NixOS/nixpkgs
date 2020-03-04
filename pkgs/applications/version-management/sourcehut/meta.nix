{ stdenv, fetchgit, buildPythonPackage
, python
, pgpy, srht, redis, bcrypt, qrcode, stripe, zxcvbn, alembic, pystache
, sshpubkeys, weasyprint, prometheus_client }:

buildPythonPackage rec {
  pname = "metasrht";
  version = "0.41.10";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    rev = version;
    sha256 = "1srzrajgwq85kjryxykj708m2c98r6a84x4k4a5grwznqw3mwm6p";
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
    prometheus_client
  ];

  patches = [
    ./use-srht-path.patch
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/meta.sr.ht;
    description = "Account management service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
