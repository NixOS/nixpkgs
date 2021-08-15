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
  version = "0.56.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "meta.sr.ht";
    rev = version;
    sha256 = "sha256-+fCNtW+k9fmjh1TLK0WUv0EgWKGlhURYS6atUH5EOjM=";
  };

  buildApi = src: buildGoModule {
    inherit src version;
    pname = "metasrht-api";
    vendorSha256 = "sha256-m9j9tmss+utTVMywI9wB1n9EK8sbElW0ej2YqK1yL5M=";
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

  pythonImportsCheck = [ "metasrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    description = "Account management service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
