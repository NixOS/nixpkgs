{ stdenv, fetchgit, buildPythonPackage
, python
, buildGoModule
, srht, redis, celery, pyyaml, markdown }:

let
  version = "0.47.9";

  buildWorker = src: buildGoModule {
    inherit src version;
    pname = "builds-sr-ht-worker";
    goPackagePath = "git.sr.ht/~sircmpwn/builds.sr.ht/worker";

    modSha256 = "1jm259ncw8dgqp0fqbjn30c4y3v3vwqj41gfh99jx30bwlmpgfax";
  };
in buildPythonPackage rec {
  inherit version;
  pname = "buildsrht";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/builds.sr.ht";
    rev = version;
    sha256 = "1zgaba58svhksxb1pzz8bym9p0pm7fnxsj5k6jz86095xmfijp34";
  };

  patches = [
    ./use-srht-path.patch
  ];

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    redis
    celery
    pyyaml
    markdown
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

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/builds.sr.ht;
    description = "Continuous integration service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
