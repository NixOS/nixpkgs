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
  version = "0.71.6";

  buildWorker = src: buildGoModule {
    inherit src version;
    pname = "builds-sr-ht-worker";

    vendorSha256 = "sha256-ZEarWM/33t+pNXUEIpfd/DkBkhu3UUg17Hh8XXWOepA=";
  };
in
buildPythonPackage rec {
  inherit version;
  pname = "buildsrht";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "builds.sr.ht";
    rev = version;
    sha256 = "sha256-c2xp2uIP8+WeRMz0efA1H58Nkot65bc03e7rrrZk3jo=";
  };

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

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/builds.sr.ht";
    description = "Continuous integration service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
