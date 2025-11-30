{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "ffpb";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7eVqbLpMHS1sBw2vYS4cTtyVdnnknGtEI8190VlXflk=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.tqdm ];

  # tests require working internet connection
  doCheck = false;

  meta = {
    description = "FFmpeg progress formatter to display a nice progress bar and an adaptative ETA timer";
    homepage = "https://github.com/althonos/ffpb";
    changelog = "https://github.com/althonos/ffpb/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CaptainJawZ ];
    mainProgram = "ffpb";
  };
}
