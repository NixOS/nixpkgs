{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libansilove";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "ansilove";
    repo = "libansilove";
    tag = finalAttrs.version;
    hash = "sha256-eQP4tJ7cHnSP0TI0KZXzobo5Hb5wCUms15ViM6ys6wg=";
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
