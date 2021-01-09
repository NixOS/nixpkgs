{ stdenv, fetchgit, buildPythonPackage
, python
, buildGoModule
, pgpy, srht, redis, bcrypt, qrcode, stripe, zxcvbn, alembic, pystache
, sshpubkeys, weasyprint }:

let
  version = "0.51.2";

  buildAPI = src: buildGoModule {
    inherit src version;
    pname = "metasrht-api";

    vendorSha256 = "0k7i7j604wqvzjavmcsw7g2x059jkkgrgz1qyvzlqc0y4ws59xkq";
  };
in buildPythonPackage rec {
  pname = "metasrht";
  inherit version;

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    rev = version;
    sha256 = "0c9y1hzx3dj0awxrhkzrcsmy6q9fqm6v6dbp9y1ria3v47xa3nv7";
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

  preBuild = ''
    export PKGVER=${version}
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp ${buildAPI "${src}/api"}/bin/api $out/bin/metasrht-api
  '';

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    description = "Account management service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
