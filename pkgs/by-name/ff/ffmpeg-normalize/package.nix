{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.36.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "ffmpeg_normalize";
    hash = "sha256-85gfTGHLsLteHdVdy/NBFzta7JJfjeCFBgelHOKgNH8=";
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
      'requires = ["uv_build>=0.8.14,<0.9.0"]' \
      'requires = ["uv_build==${uv-build.version}"]' \
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
