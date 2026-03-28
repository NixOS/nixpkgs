{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  python,
  srht,
  setuptools-scm,
  pip,
  pythonOlder,
  unzip,
}:

let
  version = "0.27.5";
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
    repo = "hub.sr.ht";
    rev = version;
    hash = "sha256-UhRQ4CLO2E7HYVDeXKd2+TXIVrWWkhreNOpcAiib0EY=";
  };

  hubsrht-api = buildGoModule (
    {
      inherit src version;
      pname = "hubsrht-api";
      vendorHash = "sha256-wLNNMbzSm++pK868WeUvQSYM1C9apWf4VEhoGq8rH/0=";
      env.PKGVER = version;
      subPackages = [ "./api" ];
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version;
  pname = "hubsrht";
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
    PKGVER = version;
    SRHT_PATH = "${srht}/${python.sitePackages}/srht";
    PREFIX = placeholder "out";
  };

  postBuild = ''
    make SASSC_INCLUDE=-I${srht}/share/sourcehut/scss/ all-share
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s ${hubsrht-api}/bin/api $out/bin/hub.sr.ht-api
    install -Dm644 schema.sql $out/share/sourcehut/hub.sr.ht-schema.sql
    make install-share
  '';

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "hubsrht"
  ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    description = "Project hub service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = [ ];
  };
}
