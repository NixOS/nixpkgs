{ lib
, python312
, fetchPypi
, fetchFromGitHub
}:
with python312.pkgs;
buildPythonApplication rec {
  pname = "grab-site";
  version = "2.2.7";

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    rev = version;
    owner = "ArchiveTeam";
    repo = "grab-site";
    hash = "sha256-tf8GyFjya3+TVc2VjlY6ztfjCJgof6tg4an18pz+Ig8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"wpull @ https://github.com/ArchiveTeam/ludios_wpull/tarball/master#egg=wpull-3.0.9"' '"wpull"'
  '';

  propagatedBuildInputs = [
    click
    ludios_wpull
    manhole
    lmdb
    autobahn
    fb-re2
    websockets
    faust-cchardet
  ];

  checkPhase = ''
    export PATH=$PATH:$out/bin
    bash ./tests/offline-tests
  '';

  meta = with lib; {
    description = "Crawler for web archiving with WARC output";
    homepage = "https://github.com/ArchiveTeam/grab-site";
    license = licenses.mit;
  };
}
