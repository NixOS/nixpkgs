{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg,
}:
python3Packages.buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.28.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8wNPuVRQRQpFK6opgwqdKYMYmAFRqq8p/T5V9kC8QaY=";
  };

  propagatedBuildInputs = [
    ffmpeg
    python3Packages.ffmpeg-progress-yield
  ];
  dependencies = with python3Packages; [ colorlog ];

  checkPhase = ''
    $out/bin/ffmpeg-normalize --help > /dev/null
  '';

  meta = {
    description = "Normalize audio via ffmpeg";
    homepage = "https://github.com/slhck/ffmpeg-normalize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      prusnak
    ];
    mainProgram = "ffmpeg-normalize";
  };
}
