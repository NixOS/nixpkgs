{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  srht,
  aiosmtpd,
  asyncpg,
  pygit2,
  emailthreads,
  python,
  unzip,
  pip,
  pythonOlder,
  setuptools-scm,
}:

let
  version = "0.62.3";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
  };

  patches = [ ./patches/core-go-update/lists/patch-deps.patch ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "lists.sr.ht";
    rev = version;
    hash = "sha256-HU3hnKdIoseCo1/lt3GIOQ5d3joykN11/Bzvk4xvH4Y=";
  };

  listssrht-api = buildGoModule (
    {
      inherit src version patches;
      pname = "listssrht-api";
      modRoot = "api";
      vendorHash = "sha256-XKDEr8ESs9oBh7DKu2jgPEMDY99nN25inkNwU/rrza8=";
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version patches;
  pname = "listssrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
    aiosmtpd
    asyncpg
    pygit2
    # Unofficial dependency
    emailthreads
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
    ln -s ${listssrht-api}/bin/api $out/bin/lists.sr.ht-api
    install -Dm644 schema.sql $out/share/sourcehut/lists.sr.ht-schema.sql
    make install-share
  '';

  pythonImportsCheck = [ "listssrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      eadwu
      christoph-heiss
    ];
  };
}
