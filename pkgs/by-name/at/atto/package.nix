{
  lib,
  stdenv,
  fetchcvs,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atto";
  version = "1.22-unstable-2026-10-29"; # VERSION 1.22 from header.h

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchcvs {
    cvsRoot = ":pserver:anoncvs@anoncvs.NetBSD.org:/cvsroot";
    module = "src/usr.bin/atto";
    date = "2026-10-30"; # Corresponds to 00:00 UTC, so choose the day after the commit date
    hash = "sha256-x/d4TRzkcysh6DL8LgoRAIF+c6A/uGsWW1sm5o0Tmp0=";
  };

  sourceRoot = "${finalAttrs.src.name}/usr.bin/atto";

  outputs = [
    "out"
    "man"
  ];

  buildInputs = [ ncurses ];

  env.NIX_CFLAGS_COMPILE = "-D_DEFAULT_SOURCE -D_DARWIN_C_SOURCE";

  buildPhase = ''
    runHook preBuild
    $CC $CFLAGS $LDFLAGS *.c -o atto -lncursesw
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 atto -t $out/bin
    install -Dm644 atto.1 -t $out/share/man/man1
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    # atto -h prints the usage but exits with 1
    ($out/bin/atto -h || true) 2>&1 | grep -F 'usage:'
    runHook postInstallCheck
  '';

  meta = {
    description = "Smallest functional Emacs in less than 2000 lines of C";
    homepage = "https://man.netbsd.org/atto.1";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "atto";
    platforms = lib.platforms.all;
  };
})
