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
, python
, unzip
}:
let
  version = "0.83.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "builds.sr.ht";
    rev = version;
    hash = "sha256-u/y+sYu/09LypWI/ngghbge5SvkuLQpray10j0SjlOo=";
  };

  buildsrht-api = buildGoModule ({
    inherit src version;
    pname = "buildsrht-api";
    modRoot = "api";
    vendorHash = "sha256-DfVWr/4J4ZrhHpy9CXPaAQcbag/9FmDgiexcNo0lEsk=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion= "0.17.20"; });

  buildsrht-worker = buildGoModule {
    inherit src version;
    sourceRoot = "source/worker";
    pname = "buildsrht-worker";
    vendorHash = "sha256-y5RFPbtaGmgPpiV2Q3njeWORGZF1TJRjAbY6VgC1hek=";
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
