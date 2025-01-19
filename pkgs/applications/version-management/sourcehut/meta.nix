{
  lib,
  fetchFromSourcehut,
  buildPythonPackage,
  buildGoModule,
  alembic,
  bcrypt,
  dnspython,
  qrcode,
  redis,
  srht,
  stripe,
  prometheus-client,
  zxcvbn,
  python,
  unzip,
  pip,
  pythonOlder,
  setuptools,
}:
let
  version = "0.69.8";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.43";
  };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "meta.sr.ht";
    rev = version;
    hash = "sha256-K7p6cytkPYgUuYr7BVfU/+sVbSr2YEmreIDnTatUMyk=";
  };

  metasrht-api = buildGoModule (
    {
      inherit src version;
      pname = "metasrht-api";
      modRoot = "api";
      vendorHash = "sha256-vIkUK1pigVU8vZL5xpHLeinOga5eXXHTuDkHxwUz6uM=";
    }
    // gqlgen
  );
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
    maintainers = with maintainers; [
      eadwu
      christoph-heiss
    ];
  };
}
