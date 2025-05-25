{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  srht,
  redis,
  celery,
  pyyaml,
  markdown,
  ansi2html,
  lxml,
  python,
  unzip,
  pip,
  pythonOlder,
  setuptools-scm,
}:
let
  version = "0.95.1";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
  };

  patches = [ ./patches/core-go-update/builds/patch-deps.patch ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "builds.sr.ht";
    rev = version;
    hash = "sha256-On/dKqIuqsCLAgYkJQOeYL7Ne983JzEYKhuLpD5vNu4=";
  };

  buildsrht-api = buildGoModule (
    {
      inherit src version patches;
      pname = "buildsrht-api";
      modRoot = "api";
      vendorHash = "sha256-GOM7fmJvfPJW3+XzvlwQZ9hBknlXwBKjGSmtIiapleY=";
    }
    // gqlgen
  );

  buildsrht-worker = buildGoModule (
    {
      inherit src version patches;
      pname = "buildsrht-worker";
      modRoot = "worker";
      vendorHash = "sha256-nEXnCeUxlUMNUqhe82MKREXcaC9pvqZqyqhyQW+jQjQ=";
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version patches;
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
    celery
    pyyaml
    markdown
    # Unofficial dependencies
    ansi2html
    lxml
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
    mkdir -p $out/lib
    mkdir -p $out/bin/builds.sr.ht

    cp -r images $out/lib
    cp contrib/submit_image_build $out/bin/builds.sr.ht
    ln -s ${buildsrht-api}/bin/api $out/bin/builds.sr.ht-api
    ln -s ${buildsrht-worker}/bin/worker $out/bin/builds.sr.ht-worker
    install -Dm644 schema.sql $out/share/sourcehut/builds.sr.ht-schema.sql
    make install-share
  '';

  pythonImportsCheck = [ "buildsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/builds.sr.ht";
    description = "Continuous integration service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      eadwu
      christoph-heiss
    ];
  };
}
