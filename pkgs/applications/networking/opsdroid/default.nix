{ lib, fetchpatch, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "opsdroid";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "opsdroid";
    repo = "opsdroid";
    rev = "v${version}";
    hash = "sha256-PG//UOSPNTAW6Xs8rSWWmnoBAODHmh6Js/iOes/XSAs=";
  };

  patches = [
    # https://github.com/opsdroid/opsdroid/pull/2018
    # This patch makes opsdroid much more usable on NixOS.
    (fetchpatch {
      name = "support-static-dependency-environment.patch";
      url = "https://github.com/opsdroid/opsdroid/pull/2018/commits/802e7f3500b935bae21ee915c17efa6f512ad4f0.patch";
      hash = "sha256-ahE0FVgwxIM3HmF2WFChmBeyuPbhUyYyD/YPfcMmu9k=";
    })
  ];

  disabled = !python3Packages.isPy3k;

  # tests folder is not included in release
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    click babel opsdroid-get-image-size slackclient webexteamssdk bleach
    parse emoji puremagic yamale nbformat websockets pycron nbconvert
    aiohttp matrix-api-async aioredis aiosqlite arrow pyyaml motor regex
    mattermostdriver setuptools voluptuous ibm-watson tailer multidict
    watchgod get-video-properties appdirs bitstring matrix-nio wrapt
    aiohttp-middlewares rich
  ] ++ matrix-nio.optional-dependencies.e2e;

  passthru.python = python3Packages.python;

  meta = with lib; {
    description = "An open source chat-ops bot framework";
    homepage = "https://opsdroid.dev";
    maintainers = with maintainers; [ globin willibutz ];
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "opsdroid";
  };
}
