{ lib
, fetchFromSourcehut
, buildPythonPackage
, buildGoModule
, srht
, redis
, celery
, pyyaml
, markdown
, ansi2html
, python
}:
let
  version = "0.75.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "builds.sr.ht";
    rev = version;
    sha256 = "sha256-SwyxMzmp9baRQ0vceuEn/OpfIv7z7jwq/l67hdOHXjM=";
  };

  buildWorker = src: buildGoModule {
    inherit src version;
    pname = "builds-sr-ht-worker";

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
    cp ${buildWorker "${src}/worker"}/bin/worker $out/bin/builds.sr.ht-worker
  '';

  pythonImportsCheck = [ "buildsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/builds.sr.ht";
    description = "Continuous integration service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
