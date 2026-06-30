{
  lib,
  stdenv,
  fetchurl,
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
  __structuredAttrs = true;

  buildInputs = [ ncurses ];

  postPatch = ''
    substituteInPlace aop.c \
        --replace-fail "/usr/local/share/aop" \
                        "$out/share/aop"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 aop $out/bin/aop

    install -d $out/share/aop

    install -m644 *.txt $out/share/aop/

    runHook postInstall
  '';

  meta = {
    description = "64-line ncurses based arcade game";
    homepage = "https://raffi.at/view/code/aop";
    mainProgram = "aop";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
