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
  version = "0.64.8";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "meta.sr.ht";
    rev = version;
    hash = "sha256-eiNvoy68PvjZ3iwdeNPjsXJjxAXb2PMF1/HvJquWa/U=";
  };

  metasrht-api = buildGoModule ({
    inherit src version;
    pname = "metasrht-api";
    modRoot = "api";
    vendorHash = "sha256-D3stDSb99uXze49kKZgGrAq5Zmg6hkIzIpsQKlnKVtE=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

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
    maintainers = with maintainers; [ eadwu ];
  };
}
