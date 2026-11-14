{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
  writableTmpDirAsHomeHook,
  stdenv,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "streamrip";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nathom";
    repo = "streamrip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OeU1KBGcmpryOlDmW1aFNAgSP484ZAcc4CVsgfrsKVI=";
  };

  patches = [
    ./patches/ensure-the-default-config-file-is-writable.patch
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    aiodns
    aiofiles
    aiohttp
    aiolimiter
    appdirs
    cleo
    click-help-colors
    deezer-py
    m3u8
    mutagen
    pathvalidate
    pillow
    pycryptodomex
    pytest-asyncio
    pytest-mock
    rich
    simple-term-menu
    tomlkit
    tqdm
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  # versionCheckHook does not work on darwin
  # the program tries to create its config file located at `~/Library/...`, which for some reason
  # gets resolved to /var/empty/Library/... despite $HOME being set via writableTmpDirAsHomeHook
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) versionCheckHook;

  pythonRelaxDeps = true;

  prePatch = ''
    substituteInPlace streamrip/client/downloadable.py \
      --replace-fail '"ffmpeg"' '"${lib.getExe ffmpeg}"'
  '';

  meta = {
    description = "Scriptable music downloader for Qobuz, Tidal, SoundCloud, and Deezer";
    homepage = "https://github.com/nathom/streamrip";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.quantenzitrone ];
    mainProgram = "rip";
  };
})
