{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.41.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ffmpeg_normalize";
    hash = "sha256-v5icrioELMBi2uJSdoojgY4EMnwHGxncanrT6GpSpSc=";
  };

  build-system = with python3Packages; [ uv-build ];

  dependencies =
    with python3Packages;
    [
      colorlog
      ffmpeg-progress-yield
      mutagen
    ]
    ++ [ ffmpeg ];

  pythonRelaxDeps = [
    "colorlog"
  ];

  checkPhase = ''
    runHook preCheck

    $out/bin/ffmpeg-normalize --help > /dev/null

    runHook postCheck
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
