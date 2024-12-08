{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "opsdroid";
  version = "0.30.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opsdroid";
    repo = "opsdroid";
    rev = "refs/tags/v${version}";
    hash = "sha256-7H44wdhJD4Z6OP1sUmSGlepuvx+LlwKLq7iR8cwqR24=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-middlewares
    aioredis
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
    (matrix-nio.override { withOlm = true; })
    mattermostdriver
    motor
    multidict
    nbconvert
    nbformat
    opsdroid-get-image-size
    parse
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

  meta = with lib; {
    description = "Open source chat-ops bot framework";
    homepage = "https://opsdroid.dev";
    changelog = "https://github.com/opsdroid/opsdroid/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      globin
      willibutz
    ];
    platforms = platforms.unix;
    mainProgram = "opsdroid";
  };
}
