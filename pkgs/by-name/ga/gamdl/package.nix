{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "gamdl";
  version = "2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glomatico";
    repo = "gamdl";
    rev = "37c857b503ca9ea32c4b39669bbb2d23064f39ff";
    hash = "sha256-uwl/K0KbZKwJ8mxiQOP+nGB3I69X5wv3HhfxBiiv/VM=";
  };

  pythonRelaxDeps = [
    "click"
    "pillow"
    "yt-dlp"
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    async-lru
    click
    httpx
    inquirerpy
    m3u8
    mutagen
    pillow
    pywidevine
    yt-dlp
  ];

  doCheck = false; # no tests

  meta = {
    description = "Command-line app for downloading Apple Music songs, music videos and post videos";
    homepage = "https://github.com/glomatico/gamdl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bdim404 ];
    platforms = lib.platforms.all;
  };
}
