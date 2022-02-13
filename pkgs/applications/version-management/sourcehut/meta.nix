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
  version = "0.57.5";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "meta.sr.ht";
    rev = version;
    sha256 = "sha256-qsCwZaCiqvY445U053OCWD98jlIUi9NB2jWVP2oW3Vk=";
  };

  buildApi = src: buildGoModule {
    inherit src version;
    pname = "metasrht-api";
    vendorSha256 = "sha256-8Ubrr9qRlgW2wsLHrPHwulSWLz+gp4VPcTvOZpg8TYM=";
  };

in
buildPythonPackage rec {
  pname = "metasrht";
  inherit version src;

  patches = [
    # Revert change breaking Unix socket support for Redis
    patches/redis-socket/meta/0001-Revert-Add-webhook-queue-monitoring.patch
  ];

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

  pythonImportsCheck = [ "metasrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    description = "Account management service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
