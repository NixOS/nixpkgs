{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "msgpuck";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "rtsisyk";
    repo = "msgpuck";
    rev = version;
    sha256 = "0cjq86kncn3lv65vig9cqkqqv2p296ymcjjbviw0j1s85cfflps0";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "Simple and efficient MsgPack binary serialization library in a self-contained header file";
    homepage = "https://github.com/rtsisyk/msgpuck";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
