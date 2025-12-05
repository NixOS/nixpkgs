{
  lib,
  python3,
  fetchFromGitHub,
  ffmpeg,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "shaq";
  version = "0.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "shaq";
    rev = "v${version}";
    hash = "sha256-RF606Aeskqbx94H5ivd+RJ+Hk0iYsds/PUY8TZqirs4=";
  };

  nativeBuildInputs = [
    python3.pkgs.flit-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyaudio
    pydub
    rich
    shazamio
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      build
      shaq
    ];
    lint = [
      black
      mypy
      ruff
    ];
    test = [
      pretend
      pytest
      pytest-cov
    ];
  };

  pythonImportsCheck = [ "shaq" ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  meta = with lib; {
    description = "CLI client for Shazam";
    homepage = "https://github.com/woodruffw/shaq";
    changelog = "https://github.com/woodruffw/shaq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      mig4ng
    ];
    mainProgram = "shaq";
  };
}
