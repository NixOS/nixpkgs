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
  setuptools-scm,
}:
let
  version = "0.72.11";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
  };

  patches = [ ./patches/core-go-update/meta/patch-deps.patch ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "meta.sr.ht";
    rev = version;
    hash = "sha256-dh+9wSQLL69xZ2Elmkyb9vEwpE7U7szz62VVS/0IM7Q=";
  };

  metasrht-api = buildGoModule (
    {
      inherit src version patches;
      pname = "metasrht-api";
      modRoot = "api";
      vendorHash = "sha256-z4gRqI05t3m7ANyDJHmBcOCW476IG/eTfLetPRPbqtg=";
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  pname = "metasrht";
  inherit version src patches;
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pip
    setuptools-scm
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
    maintainers = with maintainers; [
      eadwu
      christoph-heiss
    ];
  };
}
