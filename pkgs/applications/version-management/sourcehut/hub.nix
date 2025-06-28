{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  python,
  srht,
  setuptools-scm,
  pip,
  pyyaml,
  pythonOlder,
  unzip,
}:

let
  version = "0.20.2";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
  };

  patches = [ ./patches/core-go-update/hub/patch-deps.patch ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hub.sr.ht";
    rev = version;
    hash = "sha256-blaaJ7kQBkswmSpEVEsDm6vaxuMuCcW2wmeN+fbwzjg=";
  };

  hubsrht-api = buildGoModule (
    {
      inherit src version patches;
      pname = "hubsrht-api";
      modRoot = "api";
      vendorHash = "sha256-jKNHZrFydp3+cD8MR2izzE8bi4H2uT/7+x/wmPkEIIc=";
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version patches;
  pname = "hubsrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
    pyyaml
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
    maintainers = with maintainers; [
      eadwu
      christoph-heiss
    ];
  };
}
