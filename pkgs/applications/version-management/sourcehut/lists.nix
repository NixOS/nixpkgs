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
  version = "0.70.4";
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
    repo = "lists.sr.ht";
    rev = version;
    hash = "sha256-d7JQ0apJnJar8Sk+A7NOa3ppBsqGlE1CySLxfiLIa0M=";
  };

  listssrht-go = buildGoModule (
    {
      inherit src version;
      pname = "listssrht-go";
      vendorHash = "sha256-sk87Sokb/UQ+k/qojLGNaFdhYMpsOYox7fI5clZa/Hc=";
      env.PKGVER = version;
      subPackages = [
        "./api"
        "./ingress"
      ];
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version;
  pname = "listssrht";
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
    mkdir -p $out/bin
    ln -s ${listssrht-go}/bin/api $out/bin/lists.sr.ht-api
    ln -s ${listssrht-go}/bin/ingress $out/bin/lists.sr.ht-ingress
    install -Dm644 schema.sql $out/share/sourcehut/lists.sr.ht-schema.sql
    make install-share
  '';

  pythonImportsCheck = [ "listssrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = [ ];
  };
}
