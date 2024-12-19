{ lib, python3Packages, fetchFromGitHub, gitUpdater }:

python3Packages.buildPythonApplication rec {
  pname = "moodle-dl";
  version = "2.3.13";

  src = fetchFromGitHub {
    owner = "C0D3D3V";
    repo = "Moodle-DL";
    rev = "refs/tags/${version}";
    hash = "sha256-6arwc72gu7XyT6HokSEs2TkvE2FG7mIvy4F+/i/0eJg=";
  };

  propagatedBuildInputs = with python3Packages; [
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

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/C0D3D3V/Moodle-Downloader-2";
    maintainers = [ maintainers.kmein ];
    description = "Moodle downloader that downloads course content fast from Moodle";
    mainProgram = "moodle-dl";
    license = licenses.gpl3Plus;
  };
}
