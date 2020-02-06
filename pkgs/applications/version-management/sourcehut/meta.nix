{ stdenv, fetchgit, buildPythonPackage
, python
, pgpy, srht, redis, bcrypt, qrcode, stripe, zxcvbn, alembic, pystache
, sshpubkeys, weasyprint, prometheus_client }:

buildPythonPackage rec {
  pname = "metasrht";
  version = "0.37.0";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    rev = version;
    sha256 = "1jf3h2v27cbam8bwiw3x35319pzp0r651p8mfhw150jvskyvmkmr";
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
