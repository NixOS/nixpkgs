{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gd,
}:

stdenv.mkDerivation rec {
  pname = "libansilove";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "ansilove";
    repo = "libansilove";
    tag = version;
    hash = "sha256-kbQ7tbQbJ8zYhdbfiVZY26woyR4NNzqjCJ/5nrunlWs=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ gd ];

  meta = {
    description = "Library for converting ANSI, ASCII, and other formats to PNG";
    homepage = "https://github.com/ansilove/libansilove";
    changelog = "https://github.com/ansilove/libansilove/blob/${src.rev}/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jethair ];
    mainProgram = "libansilove";
    platforms = lib.platforms.unix;
  };
}
