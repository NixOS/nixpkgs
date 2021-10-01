{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-jellyfin";
  version = "1.0.2";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-Jellyfin";
    sha256 = "0j7v5xx3c401r5dw1sqm1n2263chjga1d3ml85rg79hjhhhacy75";
  };

  propagatedBuildInputs = [ mopidy python3Packages.unidecode python3Packages.websocket-client ];

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
