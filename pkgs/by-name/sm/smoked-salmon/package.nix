{
  lib,
  fetchFromGitHub,
  ffmpeg-headless,
  flac,
  lame,
  mp3val,
  python3Packages,
  sox,
}:
let
  runtimeDeps = [
    ffmpeg-headless
    flac
    lame
    mp3val
    sox
  ];
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "smoked-salmon";
  version = "0.9.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smokin-salmon";
    repo = "smoked-salmon";
    tag = finalAttrs.version;
    hash = "sha256-JOwqu/Hu7BjYLo3DdL6o+9TI/OQvlgj5Xu8WQ0cujwo=";
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
    deluge-client
    ffmpeg-python
    filetype
    httpx
    humanfriendly
    jinja2
    msgspec
    musicbrainzngs
    mutagen
    pillow
    platformdirs
    pycambia
    pyoxipng
    pyperclip
    qbittorrent-api
    ratelimit
    requests
    rich
    send2trash
    setuptools
    torf
    tqdm
    transmission-rpc
    unidecode
    wheel
  ];

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath finalAttrs.passthru.runtimeDeps)
  ];

  passthru = {
    inherit runtimeDeps;
  };

  meta = {
    description = "Toolkit for checking, editing and uploading music to Gazelle-based trackers";
    homepage = "https://github.com/smokin-salmon/smoked-salmon";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "salmon";
    maintainers = with lib.maintainers; [
      ambroisie
      undefined-landmark
    ];
  };
})
