{
  lib,
  python3Packages,
  fetchPypi,
  mopidy,
}:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-jellyfin";
  version = "1.0.5";

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Jellyfin";
    hash = "sha256-cZliraTxTAJ2dXaxttWI3x4wCkmEhEo33GTNtAYwgTc=";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.unidecode
    python3Packages.websocket-client
  ];

  # no tests implemented
  doCheck = false;
  pythonImportsCheck = [ "mopidy_jellyfin" ];

  meta = with lib; {
    homepage = "https://github.com/jellyfin/mopidy-jellyfin";
    description = "Mopidy extension for playing audio files from Jellyfin";
    license = licenses.asl20;
    maintainers = [ maintainers.pstn ];
  };
}
