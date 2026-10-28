{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libansilove";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "ansilove";
    repo = "libansilove";
    tag = finalAttrs.version;
    hash = "sha256-UcpUrYZKZqCeq0+SxTFsgVogQms7yEI2ced9wRj1iMY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ gd ];

  meta = {
    description = "Library for converting ANSI, ASCII, and other formats to PNG";
    homepage = "https://github.com/ansilove/libansilove";
    changelog = "https://github.com/ansilove/libansilove/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jethair ];
    mainProgram = "libansilove";
    platforms = lib.platforms.unix;
  };
})
