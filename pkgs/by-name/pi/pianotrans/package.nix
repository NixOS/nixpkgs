{
  lib,
  fetchFromGitHub,
  python3,
  ffmpeg,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pianotrans";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "azuwis";
    repo = "pianotrans";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gRbyUQmPtGvx5QKAyrmeJl0stp7hwLBWwjSbJajihdE=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    piano-transcription-inference
    resampy
    tkinter
    torch
  ];

  # Project has no tests
  doCheck = false;

  makeWrapperArgs = [
    ''--prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"''
  ];

  meta = {
    description = "Simple GUI for ByteDance's Piano Transcription with Pedals";
    mainProgram = "pianotrans";
    homepage = "https://github.com/azuwis/pianotrans";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ azuwis ];
  };
})
