{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libansilove,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ansilove";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "ansilove";
    repo = "ansilove";
    tag = finalAttrs.version;
    hash = "sha256-U8SKh+GBwtuJbHeB7x430YmbOdS38CIBsNXCWvs8XY8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ libansilove ];

  meta = {
    description = "ANSI and ASCII art to PNG converter in C";
    homepage = "https://github.com/ansilove/ansilove";
    changelog = "https://github.com/ansilove/ansilove/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jethair ];
    mainProgram = "ansilove";
    platforms = lib.platforms.unix;
  };
})
