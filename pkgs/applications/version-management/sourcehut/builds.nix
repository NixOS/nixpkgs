{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, redis
, celery
, pyyaml
, markdown
, ansi2html
, lxml
, python
, unzip
, pip
, pythonOlder
, setuptools
}:
let
  version = "0.89.15";
  gqlgen = import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion = "0.17.39"; };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "builds.sr.ht";
    rev = version;
    hash = "sha256-rmNaBnTPDDQO/ImkGkMwW8fyjQyBUBchTEnbtAK24pw=";
  };

  buildsrht-api = buildGoModule ({
    inherit src version;
    pname = "buildsrht-api";
    modRoot = "api";
    vendorHash = "sha256-dwpuB+aYqzhGSdGVq/F9FTdHWMBkGMtVuZ7I3hB3b+Q=";
  } // gqlgen);

  buildsrht-worker = buildGoModule ({
    inherit src version;
    pname = "buildsrht-worker";
    modRoot = "worker";
    vendorHash = "sha256-dwpuB+aYqzhGSdGVq/F9FTdHWMBkGMtVuZ7I3hB3b+Q=";
  } // gqlgen);
in
buildPythonPackage rec {
  inherit src version;
  pname = "buildsrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api worker" ""
  '';

  nativeBuildInputs = [
    pip
    setuptools
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

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    mkdir -p $out/lib
    mkdir -p $out/bin/builds.sr.ht

    cp -r images $out/lib
    cp contrib/submit_image_build $out/bin/builds.sr.ht
    ln -s ${buildsrht-api}/bin/api $out/bin/buildsrht-api
    ln -s ${buildsrht-worker}/bin/worker $out/bin/buildsrht-worker
  '';

  pythonImportsCheck = [ "buildsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/builds.sr.ht";
    description = "Continuous integration service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu christoph-heiss ];
  };
}
