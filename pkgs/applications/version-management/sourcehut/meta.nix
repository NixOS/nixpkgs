{ lib
, fetchFromSourcehut
, buildPythonPackage
, buildGoModule
, alembic
, bcrypt
, dnspython
, qrcode
, redis
, srht
, stripe
, prometheus-client
, zxcvbn
, python
, unzip
, pip
, pythonOlder
, setuptools
}:
let
  version = "0.68.5";
  gqlgen = import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion = "0.17.36"; };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "meta.sr.ht";
    rev = version;
    hash = "sha256-mwUqBzi7nMTZL7uwv7hBjGkO8U3krXXpvfUCaYHgHBU=";
  };

  metasrht-api = buildGoModule ({
    inherit src version;
    pname = "metasrht-api";
    modRoot = "api";
    vendorHash = "sha256-4T1xnHDjxsIyddA51exNwwz6ZWeuT7N8LBsCJ7c8sRI=";
  } // gqlgen);
in
buildPythonPackage rec {
  pname = "metasrht";
  inherit version src;
  pyproject = true;

  disabled = pythonOlder "3.7";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

  nativeBuildInputs = [
    pip
    setuptools
  ];

  propagatedBuildInputs = [
    alembic
    bcrypt
    dnspython
    qrcode
    redis
    srht
    stripe
    prometheus-client
    zxcvbn
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
    maintainers = with maintainers; [ eadwu christoph-heiss ];
  };
}
