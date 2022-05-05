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
  version = "0.58.8";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "meta.sr.ht";
    rev = version;
    sha256 = "sha256-lnEt5UoQBd5qlkD+nE6KL5DP4jf1FrAjgA06/mgRxTs=";
  };

  metasrht-api = buildGoModule ({
    inherit src version;
    pname = "metasrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-3s9PYUy4qS06zyTIRDvnAmhfrjVLBa/03Nu3tMcIReI=";
  } // import ./fix-gqlgen-trimpath.nix {inherit unzip;});

in
buildPythonPackage rec {
  pname = "metasrht";
  inherit version src;

  patches = [
    # Revert change breaking Unix socket support for Redis
    patches/redis-socket/meta/0001-Revert-Add-webhook-queue-monitoring.patch
  ];
  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

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
