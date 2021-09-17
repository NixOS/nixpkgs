{ lib
, fetchFromSourcehut
, buildPythonPackage
, buildGoModule
, pgpy
, srht
, redis
, bcrypt
, qrcode
, stripe
, zxcvbn
, alembic
, pystache
, dnspython
, sshpubkeys
, weasyprint
, prometheus-client
, python
}:
let
  version = "0.53.14";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "meta.sr.ht";
    rev = version;
    sha256 = "sha256-/+r/XLDkcSTW647xPMh5bcJmR2xZNNH74AJ5jemna2k=";
  };

  buildApi = src: buildGoModule {
    inherit src version;
    pname = "metasrht-api";
    vendorSha256 = "sha256-eZyDrr2VcNMxI++18qUy7LA1Q1YDlWCoRtl00L8lfR4=";
  };

in
buildPythonPackage rec {
  pname = "metasrht";
  inherit version src;

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
    prometheus-client
    dnspython
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp ${buildApi "${src}/api/"}/bin/api $out/bin/metasrht-api
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    description = "Account management service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
