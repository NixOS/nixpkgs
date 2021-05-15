{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, redis
, pyyaml
, buildsrht
, writeText
}:

buildPythonPackage rec {
  pname = "scmsrht";
  version = "0.22.9";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scm.sr.ht";
    rev = version;
    sha256 = "sha256-327G6C8FW+iZx+167D7TQsFtV6FGc8MpMVo9L/cUUqU=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    redis
    pyyaml
    buildsrht
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    description = "Shared support code for sr.ht source control services.";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
