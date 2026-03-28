{
  lib,
  fetchFromSourcehut,
  buildPythonPackage,
  buildGoModule,
  bcrypt,
  dnspython,
  httpx,
  prometheus-client,
  pydantic,
  qrcode,
  redis,
  srht,
  zxcvbn,
  python,
  unzip,
  pip,
  pythonOlder,
  setuptools-scm,
}:
let
  version = "0.87.1";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
    generatePaths = [
      "./api/loaders"
      "./api/graph"
    ];
  };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "meta.sr.ht";
    rev = version;
    hash = "sha256-xy71cX5du5RJMMFwXxwK233NzWtPV2OeT5ld4bnvNbI=";
  };

  metasrht-api = buildGoModule (
    {
      inherit src version;
      pname = "metasrht-api";
      vendorHash = "sha256-E5GcjSrY5wpTsdc+vFNKmvaeivXrRJRLsrUye7mHS78=";
      env.PKGVER = version;
      subPackages = [ "./cmd/api" ];
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  pname = "metasrht";
  inherit version src;
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    bcrypt
    dnspython
    httpx
    prometheus-client
    pydantic
    qrcode
    redis
    srht
    zxcvbn
  ];

  env = {
    PKGVER = version;
    SRHT_PATH = "${srht}/${python.sitePackages}/srht";
    PREFIX = placeholder "out";
  };

  postBuild = ''
    make SASSC_INCLUDE=-I${srht}/share/sourcehut/scss/ all-share
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s ${metasrht-api}/bin/api $out/bin/meta.sr.ht-api
    install -Dm644 schema.sql $out/share/sourcehut/meta.sr.ht-schema.sql
    make install-share
  '';

  pythonImportsCheck = [ "metasrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    description = "Account management service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = [ ];
  };
}
