{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  srht,
  python,
  unzip,
  pip,
  pythonOlder,
  setuptools-scm,
}:

let
  version = "unstable-2026-02-24";
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
    repo = "man.sr.ht";
    rev = "882bf816e1c3";
    hash = "sha256-Fxd7NiOg96PutzeR66L1/0fow1qsa9em5h7XTaLS6Ds=";
  };

  mansrht-api = buildGoModule (
    {
      inherit src;
      pname = "mansrht-api";
      version = "unstable-2026-02-24";
      vendorHash = "sha256-fZol10ZwnGj3jgybMeahX6AXAGO8ovxd9plgfM8ctGo=";
      env.PKGVER = version;
      subPackages = [ "./cmd/api" ];
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version;
  pname = "mansrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
  ];

  env = {
    SETUPTOOLS_SCM_PRETEND_VERSION = "0.0.0";
    PKGVER = version;
    SRHT_PATH = "${srht}/${python.sitePackages}/srht";
    PREFIX = placeholder "out";
  };

  postBuild = ''
    make SASSC_INCLUDE=-I${srht}/share/sourcehut/scss/ all-share
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s ${mansrht-api}/bin/api $out/bin/man.sr.ht-api
    install -Dm644 schema.sql $out/share/sourcehut/man.sr.ht-schema.sql
    make install-share
  '';

  pythonImportsCheck = [ "mansrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    description = "Wiki service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = [ ];
  };
}
