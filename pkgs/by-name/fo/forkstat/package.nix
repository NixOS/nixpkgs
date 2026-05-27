{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "forkstat";
  version = "0.04.00";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "forkstat";
    rev = "V${finalAttrs.version}";
    hash = "sha256-HHyGjhu8yaBvDncloW8ST2L4iUU2ik2ydW1z9pFhfrw=";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = {
    description = "Process fork/exec/exit monitoring tool";
    mainProgram = "forkstat";
    homepage = "https://github.com/ColinIanKing/forkstat";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ womfoo ];
  };
})
