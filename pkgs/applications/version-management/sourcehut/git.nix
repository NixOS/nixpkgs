{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  python,
  srht,
  scmsrht,
  pygit2,
  pythonOlder,
  unzip,
  pip,
  setuptools-scm,
}:
let
  version = "0.96.4";
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
    repo = "git.sr.ht";
    rev = version;
    hash = "sha256-puSuEl7Y4WZfi+sjcHGGTqFOUr8Em0EtAf70HXW/mOQ=";
  };

  gitsrht-go = buildGoModule (
    {
      inherit src version;
      pname = "gitsrht-go";
      vendorHash = "sha256-GSRHC2k5pe5isZGMlbtINexhQ1Nj0x9+9caIPVp0qmE=";
      env.PKGVER = version;
      subPackages = [
        "./cmd/api"
        "./cmd/shell"
        "./cmd/http-clone"
        "./cmd/update-hook"
      ];
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version;
  pname = "gitsrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
    scmsrht
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
    ln -s ${gitsrht-go}/bin/api $out/bin/git.sr.ht-api
    ln -s ${gitsrht-go}/bin/shell $out/bin/git.sr.ht-shell
    ln -s ${gitsrht-go}/bin/http-clone $out/bin/git.sr.ht-http-clone
    ln -s ${gitsrht-go}/bin/update-hook $out/bin/git.sr.ht-update-hook
    install -Dm644 schema.sql $out/share/sourcehut/git.sr.ht-schema.sql
    make PREFIX=$out install-share
  '';

  pythonImportsCheck = [ "gitsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    description = "Git repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = [ ];
  };
}
