{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "arkurses";
  version = "0-unstable-2013-10-28";

  src = fetchFromGitHub {
    owner = "gilzoide";
    repo = "Arkurses";
    rev = "0661ced1b64d006b0663e4df677c9d7166befd16";
    hash = "sha256-dnIn9o0oA0rRBKo+nZZLdPAyOfF4Wo/Ak7C3J7EnGOA=";
  };

  strictDeps = true;

  buildInputs = [ ncurses ];

  buildPhase = ''
    runHook preBuild

    $CC $CPPFLAGS $CFLAGS arkurses.c -o arkurses \
      $LDFLAGS -lpanel -lncurses

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 arkurses -t "$out/bin"
    install -Dm644 README.md -t "$out/share/doc/arkurses"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Arkanoid clone in a terminal, using ncurses";
    homepage = "https://github.com/gilzoide/Arkurses";
    license = lib.licenses.unfree;
    mainProgram = "arkurses";
    maintainers = with lib.maintainers; [ Zaczero ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
