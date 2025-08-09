{
  lib,
  python3Packages,
  fetchFromGitHub,

  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "streamrip";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nathom";
    repo = "streamrip";
    rev = "v${version}";
    hash = "sha256-Klrkz0U36EIGO2sNxTnKPACvvqu1sslLFFrQRjFdxiE=";
  };

  patches = [
    ./patches/ensure-the-default-config-file-is-writable.patch
  ];

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
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

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonRelaxDeps = true;

  prePatch = ''
    sed -i 's#"ffmpeg"#"${lib.getBin ffmpeg}/bin/ffmpeg"#g' streamrip/client/downloadable.py
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Scriptable music downloader for Qobuz, Tidal, SoundCloud, and Deezer";
    homepage = "https://github.com/nathom/streamrip";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "rip";
  };
}
