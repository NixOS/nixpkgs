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
  version = "0.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smokin-salmon";
    repo = "smoked-salmon";
    tag = version;
    hash = "sha256-GxH2hqA/11yqLC8fH3GVvfohAmTxy/ibqxa0Xcupxn0=";
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

  passthru = {
    inherit runtimeDeps;
  };

  meta = {
    description = "Uploading script for Gazelle-based music trackers";
    homepage = "https://github.com/smokin-salmon/smoked-salmon";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "salmon";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
