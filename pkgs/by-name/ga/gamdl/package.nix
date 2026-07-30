{
  lib,
  fetchFromGitHub,
  python3Packages,
  rustPlatform,
}:

python3Packages.buildPythonApplication rec {
  pname = "gamdl";
  version = "3.8.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "glomatico";
    repo = "gamdl";
    tag = version;
    hash = "sha256-wmshPsxJoV+gXzlY6Fz0oiPl8+QZ6P0K/h4IebxZz7w=";
  };

  cargoRoot = "gamdl/downloader/ammuxer";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-qUpS+FxPxGt+692epTQLXjN1BsD2Wi0XK6lHnwArpu8=";
  };

  build-system = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  dependencies = with python3Packages; [
    async-lru
    click
    colorama
    dataclass-click
    httpx
    httpx-retries
    inquirerpy
    m3u8
    mutagen
    pillow
    pywidevine
    structlog
    yt-dlp
  ];

  doCheck = false;

  pythonImportsCheck = [ "gamdl" ];

  meta = {
    description = "Command-line app for downloading Apple Music songs, music videos and post videos";
    homepage = "https://github.com/glomatico/gamdl";
    changelog = "https://github.com/glomatico/gamdl/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bdim404 ];
    mainProgram = "gamdl";
    platforms = lib.platforms.all;
  };
}
