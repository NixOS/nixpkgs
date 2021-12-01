{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "opsdroid";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "opsdroid";
    repo = "opsdroid";
    rev = "v${version}";
    sha256 = "15l2jvcpb9l8sgdd9zsvxqglf1r3vap0pp9cklpfa9jj0aik6nx9";
  };

  disabled = !python3Packages.isPy3k;

  # tests folder is not included in release
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    click Babel opsdroid_get_image_size slackclient webexteamssdk bleach
    parse emoji puremagic yamale nbformat websockets pycron nbconvert
    aiohttp matrix-api-async aioredis aiosqlite arrow pyyaml motor regex
    mattermostdriver setuptools voluptuous ibm-watson tailer multidict
    watchgod get-video-properties appdirs bitstring matrix-nio
  ];

  passthru.python = python3Packages.python;

  meta = with lib; {
    description = "An open source chat-ops bot framework";
    homepage = "https://opsdroid.dev";
    maintainers = with maintainers; [ fpletz globin willibutz lheckemann ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
