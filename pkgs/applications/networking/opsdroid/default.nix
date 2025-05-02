{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "opsdroid";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "opsdroid";
    repo = "opsdroid";
    rev = "v${version}";
    sha256 = "0f32jf2rds9543akysxinf3hsgzr0w880xwcrcm1r2r0nhp8b8s5";
  };

  disabled = !python3Packages.isPy3k;

  # tests folder is not included in release
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    click babel opsdroid-get-image-size slackclient webexteamssdk bleach
    parse emoji puremagic yamale nbformat websockets pycron nbconvert
    aiohttp matrix-api-async aioredis aiosqlite arrow pyyaml motor regex
    mattermostdriver setuptools voluptuous ibm-watson tailer multidict
    watchgod get-video-properties appdirs bitstring matrix-nio
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
