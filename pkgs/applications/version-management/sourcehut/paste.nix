{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  srht,
  pip,
  pyyaml,
  python,
  pythonOlder,
  setuptools-scm,
  unzip,
}:

let
  version = "unstable-2026-01-27";
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
    repo = "paste.sr.ht";
    rev = "342eb3fd38a9";
    hash = "sha256-stoIIAXWvtrSnAICehLeEbCYQBkRM6qsd0Pt4RjM9E8=";
  };

  pastesrht-api = buildGoModule (
    {
      inherit src;
      pname = "pastesrht-api";
      version = "unstable-2026-01-27";
      vendorHash = "sha256-xrX3pN9xEAeAOP2mom8WrdsnwDR+UO2TWUPl+B23vWc=";
      env.PKGVER = version;
      subPackages = [ "./cmd/api" ];
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version;
  pname = "pastesrht";
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
    ln -s ${pastesrht-api}/bin/api $out/bin/paste.sr.ht-api
    make install-share
  '';

  pythonImportsCheck = [ "pastesrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/paste.sr.ht";
    description = "Ad-hoc text file hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = [ ];
  };
}
