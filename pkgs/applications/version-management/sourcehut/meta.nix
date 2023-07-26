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
, unzip
}:
let
  version = "0.61.3";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "meta.sr.ht";
    rev = version;
    hash = "sha256-wMcpdRSRvxYEV163mdTGOemk62gljua89SOtwe6qGXU=";
  };

  metasrht-api = buildGoModule ({
    inherit src version;
    pname = "metasrht-api";
    modRoot = "api";
    vendorHash = "sha256-ZoDRGmGe9o5pn89gJ60wjSp5Cc0yxRfvdhNnbwAhmSI=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion = "0.17.20"; });

in
buildPythonPackage rec {
  pname = "metasrht";
  inherit version src;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

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
    ln -s ${metasrht-api}/bin/api $out/bin/metasrht-api
  '';

  pythonImportsCheck = [ "metasrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    description = "Account management service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
