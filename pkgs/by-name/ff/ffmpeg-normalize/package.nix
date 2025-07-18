{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.31.3";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "ffmpeg_normalize";
    hash = "sha256-sewDSBUX6gCZSIHeRtpx5fQGtOKN8OWZKrtCF2bgI9Y=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    with python3Packages;
    [
      colorlog
      ffmpeg-progress-yield
    ]
    ++ [ ffmpeg ];

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
