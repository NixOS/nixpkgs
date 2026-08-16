{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "power-calibrate";
  version = "0.01.37";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "power-calibrate";
    rev = "V${finalAttrs.version}";
    hash = "sha256-DZ6rXbhaSNy3TEX+lwv3tyKQ7BXOZ9ycrff/7pF60j0=";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = {
    description = "Tool to calibrate power consumption";
    mainProgram = "power-calibrate";
    homepage = "https://github.com/ColinIanKing/power-calibrate";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
