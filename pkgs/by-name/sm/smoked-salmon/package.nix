{
  lib,
  fetchFromGitHub,
  fetchpatch,
  cambia,
  ffmpeg-headless,
  flac,
  lame,
  mp3val,
  oxipng,
  python3Packages,
  sox,
}:
let
  runtimeDeps = [
    cambia
    oxipng
    ffmpeg-headless
    flac
    lame
    mp3val
    sox
  ];
in
python3Packages.buildPythonApplication rec {
  pname = "smoked-salmon";
  version = "0.9.5-unstable-2025-06-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smokin-salmon";
    repo = "smoked-salmon";
    rev = "980bbe9dc2c5da00df41b945aa754ffcab46c3b0";
    hash = "sha256-kj+5fV1hGRtj512jLGPW49d7XpDstue8drwuzT1K9Ls=";
  };

  # Upstream tends to use very narrow version constraints
  pythonRelaxDeps = true;

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-jinja2
    beautifulsoup4
    bitstring
    click
    filetype
    httpx
    jinja2
    msgspec
    musicbrainzngs
    mutagen
    platformdirs
    pyperclip
    qbittorrent-api
    ratelimit
    requests
    rich
    send2trash
    setuptools
    torf
    tqdm
    unidecode
    wheel
  ];

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath runtimeDeps)
  ];

  meta = with lib; {
    description = "Uploading script for Gazelle-based music trackers";
    homepage = "https://github.com/smokin-salmon/smoked-salmon";
    license = with licenses; [ asl20 ];
    mainProgram = "salmon";
    maintainers = with maintainers; [ ambroisie ];
  };
}
