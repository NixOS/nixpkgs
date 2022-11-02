{ lib
, fetchFromSourcehut
, fetchpatch
, buildGoModule
, buildPythonPackage
, srht
, redis
, celery
, pyyaml
, markdown
, ansi2html
, python
, unzip
}:
let
  version = "0.82.8";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "builds.sr.ht";
    rev = version;
    hash = "sha256-M94zkEUJU8EwksN34sd5IkASDCQ0hHb98G5wzZsCrpg=";
  };

  buildsrht-api = buildGoModule ({
    inherit src version;
    pname = "buildsrht-api";
    modRoot = "api";
    vendorHash = "sha256-8z5m4bMwLeYg4i91MMjLMqbciWvqS0icCHFUJTUHBgk=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  buildsrht-worker = buildGoModule {
    inherit src version;
    sourceRoot = "source/worker";
    pname = "buildsrht-worker";
    vendorHash = "sha256-y5RFPbtaGmgPpiV2Q3njeWORGZF1TJRjAbY6VgC1hek=";

    patches = [
      (fetchpatch {
        name = "update-x-sys-for-go-1.18-on-aarch64-darwin.patch";
        url = "https://git.sr.ht/~sircmpwn/builds.sr.ht/commit/f58bbde6bfed7d2321a3b17e991c91fc83d4c230.patch";
        stripLen = 1;
        hash = "sha256-vQR/T5G5Gz5tY+SEZZabsbnFKW44b+Bs+GDdydyeCDs=";
      })
    ];
  };
in
buildPythonPackage rec {
  inherit src version;
  pname = "buildsrht";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api worker" ""
  '';

  propagatedBuildInputs = [
    srht
    redis
    celery
    pyyaml
    markdown
    ansi2html
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
    maintainers = with maintainers; [ eadwu ];
  };
}
