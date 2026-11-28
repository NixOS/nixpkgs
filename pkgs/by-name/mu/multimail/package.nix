{
  stdenv,
  lib,
  fetchFromGitHub,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "multimail";
  version = "0.52";

  src = fetchFromGitHub {
    owner = "wmcbrine";
    repo = "MultiMail";
    tag = finalAttrs.version;
    hash = "sha256-Pi/mXGpdDaAxDNN3zBmCqO4xC91dauzdh4zw5U8+TvY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  buildInputs = [ ncurses ];

  makeFlags = [
    "CXX=${stdenv.cc.targetPrefix}c++"
    "LIBS=-lncurses"
    #upstream strips the binary itself
    "POST="
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 mm $out/bin/mm
    install -Dm644 mm.1 $out/share/man/man1/mm.1
    ln -s mm.1 $out/share/man/man1/mmail.1
    runHook postInstall
  '';

  # mm has no --version flag. It prints the version on
  # very first run.

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Offline reader for QWK, Blue Wave, etc. Multi-platform, curses-based";
    homepage = "https://github.com/wmcbrine/MultiMail";
    changelog = "https://github.com/wmcbrine/MultiMail/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "mm";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
