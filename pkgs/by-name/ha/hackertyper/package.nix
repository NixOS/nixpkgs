{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "hackertyper";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "hyasynthesized";
    repo = "Hackertyper";
    rev = "8d08e3200c65817bd8c5bd0baa5032919315853b";
    hash = "sha256-XPSL193gUaMvzFUphYSdfMaU+8TBzCPAdInDmDWIGWo=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = [ ncurses ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/hackertyper -v
  '';

  meta = {
    description = "C rewrite of hackertyper.net";
    homepage = "https://github.com/hyasynthesized/Hackertyper";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.marius851000 ];
    mainProgram = "hackertyper";
  };
}
