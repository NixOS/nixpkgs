{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  srht,
  pygit2,
  python,
  unzip,
  pip,
  pythonOlder,
  setuptools-scm,
}:

let
  version = "0.18.1";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
  };

  patches = [ ./patches/core-go-update/man/patch-deps.patch ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "man.sr.ht";
    rev = version;
    hash = "sha256-c2xFC1pmOSGGMP4RVOmgFogj7CY2kHrADsWsm7M5ZK4=";
  };

  mansrht-api = buildGoModule (
    {
      inherit src version patches;
      pname = "mansrht-api";
      modRoot = "api";
      vendorHash = "sha256-jKNHZrFydp3+cD8MR2izzE8bi4H2uT/7+x/wmPkEIIc=";
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version patches;
  pname = "mansrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
    pygit2
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
    ln -s ${mansrht-api}/bin/api $out/bin/man.sr.ht-api
    install -Dm644 schema.sql $out/share/sourcehut/man.sr.ht-schema.sql
    make install-share
  '';

  pythonImportsCheck = [ "mansrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    description = "Wiki service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      eadwu
      christoph-heiss
    ];
  };
}
