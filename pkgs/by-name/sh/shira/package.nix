{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
}:

python3Packages.buildPythonApplication {
  pname = "shira";
  version = "1.7.1-unstable-2025-08-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KraXen72";
    repo = "shira";
    rev = "a7478efa434597324458441f328c1b2f84c04dbc";
    hash = "sha256-k15GaOmS0rlQBQldnLo1SzIyCkNQux6P5b7ZG2BIa90=";
  };

  build-system = [
    python3Packages.flit-core
  ];

  dependencies = with python3Packages; [
    click
    mediafile
    pillow
    python-dateutil
    requests-cache
    yt-dlp
    ytmusicapi
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
      ]
    }"
  ];

  meta = {
    description = "Download music from YouTube, YouTube Music and Soundcloud";
    homepage = "https://github.com/KraXen72/shira/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thegu5 ];
    mainProgram = "shiradl";
  };
}
