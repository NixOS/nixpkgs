{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "moodle-dl";
  version = "2.3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "C0D3D3V";
    repo = "Moodle-DL";
    tag = finalAttrs.version;
    hash = "sha256-6arwc72gu7XyT6HokSEs2TkvE2FG7mIvy4F+/i/0eJg=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aiodns
    aiofiles
    aiohttp
    certifi
    colorama
    colorlog
    html2text
    readchar
    requests
    sentry-sdk
    xmpppy
    yt-dlp
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "moodle_dl" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/C0D3D3V/Moodle-Downloader-2";
    maintainers = [ lib.maintainers.kmein ];
    description = "Moodle downloader that downloads course content fast from Moodle";
    mainProgram = "moodle-dl";
    license = lib.licenses.gpl3Plus;
  };
})
