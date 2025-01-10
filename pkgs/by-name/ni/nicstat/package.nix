{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nicstat";
  version = "0-unstable-2018-05-09";

  src = fetchFromGitHub {
    owner = "scotte";
    repo = "nicstat";
    rev = "1fbe28198b49a2062b0c928554f93db33cb288c3";
    hash = "sha256-7+11K9636dGeW0HaaH6OJF5Wy4CXYXfoaZOVfhHK6kg=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild

    $CC -O2 nicstat.c -o nicstat

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d "$out/bin"
    install -m 755 nicstat "$out/bin"

    installManPage nicstat.1

    runHook postInstall
  '';

  meta = {
    description = "Network traffic statistics utility for Solaris and Linux";
    homepage = "https://github.com/scotte/nicstat";
    changelog = "https://github.com/scotte/nicstat/blob/${finalAttrs.src.rev}/ChangeLog.txt";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ juliusrickert ];
    mainProgram = "nicstat";
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
