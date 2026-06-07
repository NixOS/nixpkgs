{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "audio-offset-finder";
  version = "0.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bbc";
    repo = "audio-offset-finder";
    tag = "v${version}";
    hash = "sha256-XIjRqm6EvQ9qp1xdMHk+6jtN5b8VwkcjoXDtXs7JvOY";
  };

  pythonRelaxDeps = [ "numpy" ];

  dependencies = with python3Packages; [
    librosa
    matplotlib
    numpy
    scipy
  ];

  build-system = [
    python3Packages.setuptools
  ];

  meta = with lib; {
    description = "Find the offset of an audio file within another audio file";
    license = licenses.apsl20;
    homepage = "https://github.com/bbc/audio-offset-finder";
    maintainers = with maintainers; [ john-rodewald ];
    mainProgram = "audio-offset-finder";
  };
}
