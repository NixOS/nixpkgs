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
  version = "0.79.1";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "builds.sr.ht";
    rev = version;
    sha256 = "sha256-8fZ6KdD+9+n0uO3jm0AUyG08oCUNFq1K55ZOwLbkpHk=";
  };

  buildsrht-api = buildGoModule ({
    inherit src version;
    pname = "buildsrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-roTwqtg4Y846PNtLdRN/LV3Jd0LVElqjFy3DJcrwoaI=";
  } // import ./fix-gqlgen-trimpath.nix {inherit unzip;});

  buildsrht-worker = buildGoModule {
    inherit src version;
    sourceRoot = "source/worker";
    pname = "buildsrht-worker";
    vendorSha256 = "sha256-Pf1M9a43eK4jr6QMi6kRHA8DodXQU0pqq9ua5VC3ER0=";
  };
in
buildPythonPackage rec {
  inherit src version;
  pname = "buildsrht";

  patches = [
    # Revert change breaking Unix socket support for Redis
    patches/redis-socket/build/0001-Revert-Add-build-submission-and-queue-monitoring.patch
  ];
  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api worker" ""
  '';

  nativeBuildInputs = srht.nativeBuildInputs;

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
