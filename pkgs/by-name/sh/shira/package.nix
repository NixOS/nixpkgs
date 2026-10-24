{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "shira";
  version = "1.8.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "KraXen72";
    repo = "shira";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SPR2Jtc6mYURwMl4c/v2fPGydBu7aOhrvetgFoBvjoM=";
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

  # Needed because of:
  # ytmusicapi==1.12.1 not satisfied by version 1.12.2
  # yt-dlp==2026.3.17 not satisfied by version 2026.7.4
  pythonRelaxDeps = [
    "ytmusicapi"
    "yt-dlp"
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      ffmpeg
    ]}"
  ];

  meta = {
    description = "Download music from YouTube, YouTube Music and Soundcloud";
    homepage = "https://github.com/KraXen72/shira/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thegu5 ];
    mainProgram = "shiradl";
  };
})
