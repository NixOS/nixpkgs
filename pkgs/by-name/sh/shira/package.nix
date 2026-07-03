{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "shira";
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KraXen72";
    repo = "shira";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SgxEvIpjRfc0saoarqw8KySwhbk1UYCGjMcbhhWMhZg=";
  };

  build-system = [
    python3Packages.hatchling
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
})
