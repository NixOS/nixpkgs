{ stdenv, fetchgit, buildPythonPackage
, python
, buildGoModule
, srht, redis, celery, pyyaml, markdown }:

let
  version = "0.52.5";

  buildWorker = src: buildGoModule {
    inherit src version;
    pname = "builds-sr-ht-worker";
    goPackagePath = "git.sr.ht/~sircmpwn/builds.sr.ht/worker";

    modSha256 = "1dwp87zsbh4a48q0pacssy329kchrd4sa47c5a1k8smbqn078424";
  };
in buildPythonPackage rec {
  inherit version;
  pname = "buildsrht";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/builds.sr.ht";
    rev = version;
    sha256 = "142aycnary6yfi0y1i3zgpyndi0756fingavcz2dnqi36pkajaaj";
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
