{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  protobuf,
  icu,
  csdr,
  codecserver,
}:

stdenv.mkDerivation rec {
  pname = "digiham";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = pname;
    rev = version;
    sha256 = "sha256-nKNA5xAhM/lyyvFJnajWwY0hwVZhLApbDkXoUYFjlt0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    codecserver
    protobuf
    csdr
    icu
  ];

  meta = {
    homepage = "https://github.com/jketterl/digiham";
    description = "tools for decoding digital ham communication";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = lib.teams.c3d2.members;
  };
}
