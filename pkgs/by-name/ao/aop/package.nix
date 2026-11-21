{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aop";
  version = "0.6";

  src = fetchurl {
    url = "https://raffi.at/code/aop/aop-${finalAttrs.version}.tar.gz";
    hash = "sha256-aKi2uPCCFrMYldU299xL6xN6eH/RcJbaLUb9hjSX9lo=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ncurses ];

  postPatch = ''
    substituteInPlace aop.c \
      --replace-fail \
        'char ch, field[25][81], tmp[96], *lastword = "Bye.";' \
        'char ch, field[25][81], tmp[256], *lastword = "Bye.";' \
      --replace-fail \
        'snprintf(tmp, 96, "/usr/local/share/aop/aop-level-%02d.txt", level);' \
        'snprintf(tmp, 256, "${placeholder "out"}/share/aop/aop-level-%02d.txt", level);'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 aop -t "$out/bin"
    install -Dm644 aop-level-*.txt -t "$out/share/aop"
    install -Dm644 README -t "$out/share/doc/aop"
    install -Dm644 COPYING -t "$out/share/licenses/aop"

    runHook postInstall
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    runHook preCheck

    output="$(./aop -h 2>&1 || :)"
    grep -Fq "Usage:" <<<"$output"

    runHook postCheck
  '';

  meta = {
    description = "Tiny curses arcade game in 64 lines of C";
    homepage = "https://raffi.at/view/code/aop";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "aop";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
