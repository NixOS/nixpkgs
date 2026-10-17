{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "opsdroid";
  version = "0.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opsdroid";
    repo = "opsdroid";
    tag = "v${version}";
    hash = "sha256-47KTxq2V+2JhV8I9BgKp+S2sAmZsy+hddewjNeWGwiw=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-middlewares
    aiosqlite
    appdirs
    arrow
    babel
    bitstring
    bleach
    # botbuilder-core, connector for teams
    certifi
    click
    # dialogflow, connector for Dialogflow
    dnspython
    emoji
    get-video-properties
    ibm-watson
    imagesize
    (matrix-nio.override { withVodozemac = true; })
    mattermostdriver
    motor
    multidict
    nbconvert
    nbformat
    parse
    pkg-resources-backport # for pkg_resources
    puremagic
    pycron
    python-olm
    pyyaml
    regex
    rich
    slack-sdk
    tailer
    voluptuous
    watchgod
    webexteamssdk
    wrapt
  ];

  passthru.python = python3Packages.python;

  # Tests are not included in releases
  doCheck = false;

  meta = {
    description = "Open source chat-ops bot framework";
    homepage = "https://opsdroid.dev";
    changelog = "https://github.com/opsdroid/opsdroid/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "opsdroid";
  };
}
