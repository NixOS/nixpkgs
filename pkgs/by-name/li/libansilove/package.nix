{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libansilove";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "ansilove";
    repo = "libansilove";
    tag = finalAttrs.version;
    hash = "sha256-JEdCcOT26r69SIjiFdpv1zTcA3pvxOOpSKuqTF01AQw=";
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
