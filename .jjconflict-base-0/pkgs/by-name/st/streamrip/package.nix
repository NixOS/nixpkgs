{ lib
, python3Packages
, fetchFromGitHub

, ffmpeg
}:

python3Packages.buildPythonApplication rec {
  pname = "streamrip";
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nathom";
    repo = "streamrip";
    rev = "v${version}";
    hash = "sha256-KwMt89lOPGt6nX7ywliG/iAJ1WnG0CRPwhAVlPR85q0=";
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

  prePatch = ''
    sed -i 's#aiofiles = ".*"#aiofiles = "*"#' pyproject.toml
    sed -i 's#deezer-py = ".*"#deezer-py = "*"#' pyproject.toml
    sed -i 's#m3u8 = ".*"#m3u8 = "*"#' pyproject.toml
    sed -i 's#pathvalidate = ".*"#pathvalidate = "*"#' pyproject.toml
    sed -i 's#Pillow = ".*"#Pillow = "*"#' pyproject.toml
    sed -i 's#pytest-asyncio = ".*"#pytest-asyncio = "*"#' pyproject.toml
    sed -i 's#tomlkit = ".*"#tomlkit = "*"#' pyproject.toml

    sed -i 's#"ffmpeg"#"${lib.getBin ffmpeg}/bin/ffmpeg"#g' streamrip/client/downloadable.py
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Scriptable music downloader for Qobuz, Tidal, SoundCloud, and Deezer";
    homepage = "https://github.com/nathom/streamrip";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ paveloom ];
    mainProgram = "rip";
  };
}
