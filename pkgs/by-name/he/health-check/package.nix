{
  stdenv,
  lib,
  fetchFromGitHub,
  json_c,
  libbsd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "health-check";
  version = "0.04.01";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "health-check";
    rev = "V${finalAttrs.version}";
    hash = "sha256-sBhFH9BNRQ684ydqh8p4TtFwO+Aygu4Ke4+/nNMlZ/E=";
  };

  buildInputs = [
    json_c
    libbsd
  ];

  makeFlags = [
    "JSON_OUTPUT=y"
    "FNOTIFY=y"
  ];

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = {
    description = "Process monitoring tool";
    mainProgram = "health-check";
    homepage = "https://github.com/ColinIanKing/health-check";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
