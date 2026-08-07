{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "powerstat";
  version = "0.04.06";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "powerstat";
    rev = "V${finalAttrs.version}";
    hash = "sha256-naCaCwteDYwIGqvffRGc5AoYMOXHP2OlKMx4zaEztmE=";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = {
    description = "Laptop power measuring tool";
    mainProgram = "powerstat";
    homepage = "https://github.com/ColinIanKing/powerstat";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ womfoo ];
  };
})
