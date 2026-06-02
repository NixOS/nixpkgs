{
  stdenv,
  lib,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smemstat";
  version = "0.02.13";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "smemstat";
    rev = "V${finalAttrs.version}";
    hash = "sha256-wxgw5tPdZAhhISbay8BwoL5zxZJV4WstDpOtv9umf54=";
  };

  buildInputs = [ ncurses ];
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = {
    description = "Memory usage monitoring tool";
    mainProgram = "smemstat";
    homepage = "https://github.com/ColinIanKing/smemstat";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ womfoo ];
  };
})
