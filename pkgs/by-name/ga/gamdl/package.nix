{
  lib,
  python3Packages,
  fetchPypi,

  # buildInputs
  ffmpeg,
}:
python3Packages.buildPythonApplication rec {
  pname = "gamdl";
  version = "2.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hxrhU5eUnz5xh6UL0D9R1YlPJFf/buoIBkIzBiqCC2Y=";
  };

  build-system = with python3Packages; [ flit ];

  buildInputs = [ ffmpeg ];

  dependencies = with python3Packages; [
    click
    colorama
    inquirerpy
    m3u8
    mutagen
    pillow
    pywidevine
    yt-dlp
  ];

  meta = {
    description = "CLI for downloading songs and videos from Apple Music";
    homepage = "https://github.com/glomatico/gamdl";
    changelog = "https://github.com/glomatico/gamdl/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ valentinegb ];
    mainProgram = "gamdl";
  };
}
