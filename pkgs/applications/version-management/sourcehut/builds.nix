{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  srht,
  redis,
  pyyaml,
  markdown,
  bleach,
  python,
  unzip,
  pip,
  pythonOlder,
  setuptools-scm,
}:
let
  version = "unstable-2026-03-04";
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
    repo = "builds.sr.ht";
    rev = "901074b3d2e9";
    hash = "sha256-ufVkP512+QjLyzlcuqBz5wgBmXRgO8YQFELmspyDlB8=";
  };

  buildsrht-go = buildGoModule (
    {
      inherit src;
      pname = "buildsrht-go";
      version = "unstable-2026-03-04";
      vendorHash = "sha256-fuXlfU4qm6ebZDlBh70DN9YWRGinwci2gKCz9D8dDpo=";
      env.PKGVER = version;
      subPackages = [
        "./cmd/api"
        "./cmd/worker"
      ];
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version;
  pname = "buildsrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
    redis
    pyyaml
    markdown
    bleach
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
    mkdir -p $out/lib
    mkdir -p $out/bin/builds.sr.ht

    cp -r images $out/lib
    cp contrib/submit_image_build $out/bin/builds.sr.ht
    ln -s ${buildsrht-go}/bin/api $out/bin/builds.sr.ht-api
    ln -s ${buildsrht-go}/bin/worker $out/bin/builds.sr.ht-worker
    install -Dm644 schema.sql $out/share/sourcehut/builds.sr.ht-schema.sql
    make install-share
  '';

  pythonImportsCheck = [ "buildsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/builds.sr.ht";
    description = "Continuous integration service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = [ ];
  };
}
