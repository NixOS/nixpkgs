{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "behacked";
  version = "0-unstable-2018-01-04";

  src = fetchFromGitHub {
    owner = "Pentachoron-Labs";
    repo = "Behacked";
    rev = "b9400899286811522a7b8d40df703872e262e731";
    hash = "sha256-U6Io4Nyj2lFfVtBpJqbJ9WrCObVfAYj1F8WH7py+C/I=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  buildInputs = [ ncurses ];

  buildPhase = ''
    runHook preBuild

    $CC behacked.c -o behacked -lncurses

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 behacked \
                   $out/bin/behacked

    runHook postInstall
  '';

  meta = {
    description = "Bejeweled inspired ncurses puzzle game";
    homepage = "https://github.com/Pentachoron-Labs/Behacked";
    mainProgram = "behacked";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
