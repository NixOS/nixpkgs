{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.38.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ffmpeg_normalize";
    hash = "sha256-qn0E2AxadOvj80rAJ+i8vyGyid8/JD0wPSKMJbM8oX0=";
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

  postPatch = with python3Packages; ''
    substituteInPlace pyproject.toml \
      --replace-fail \
      'colorlog==6.7.0' \
      'colorlog==${colorlog.version}'
  '';

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
