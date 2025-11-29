{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "gamdl";
  version = "2.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glomatico";
    repo = "gamdl";
    rev = "eab33bc02cc7c69e038426f0caa214fb1137bf04";
    hash = "sha256-8lFUoEVIKhnOay2xA9OhHRcpZti6D2oixyjEUELKNB8=";
  };

  build-system = with python3Packages; [ flit-core ];

  dependencies = with python3Packages; [
    click
    colorama
    inquirerpy
    m3u8
    mutagen
    pillow
    pywidevine
    yt-dlp
    requests
    pyyaml
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
