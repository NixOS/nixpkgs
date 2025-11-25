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

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.5)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace test/CMakeLists.txt \
      --replace-fail "cmake_policy(SET CMP0037 OLD)" "cmake_policy(SET CMP0037 NEW)"
  '';

  meta = with lib; {
    description = "Simple and efficient MsgPack binary serialization library in a self-contained header file";
    homepage = "https://github.com/rtsisyk/msgpuck";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}
