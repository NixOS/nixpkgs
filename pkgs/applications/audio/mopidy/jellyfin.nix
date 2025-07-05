{
  lib,
  python3Packages,
  fetchPypi,
  mopidy,
}:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-jellyfin";
  version = "1.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "mopidy_jellyfin";
    hash = "sha256-IKCPypMuluR0+mMALp8lB1oB1pSw4rN4rOl/eKn+Qvo=";
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
