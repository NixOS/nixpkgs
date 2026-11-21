{
  lib,
  stdenv,
  fetchgit,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solvitaire";
  version = "0-unstable-2022-05-19";

  src = fetchgit {
    url = "https://git.gir.st/solVItaire.git";
    rev = "1883ee0c67f3e5f7807f7a886333360e31f804be";
    hash = "sha256-truPFMojxdUlFzSmcdgt+WurKHKej9/0ETN8YmnmH/c=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  buildInputs = [ ncurses ];

  # makeFlags = [
  #   "CC=${stdenv.cc.targetPrefix}cc"
  # ];

  buildFlags = [
    "all"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 sol $out/bin/sol
    install -Dm755 spider $out/bin/spider
    install -Dm755 freecell $out/bin/freecell

    runHook postInstall
  '';

  meta = {
    description = "Terminal solitaire games like Klondlike, Spider and FreeCell";
    homepage = "https://gir.st/sol.html";
    mainProgram = "sol";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ castorNova2 ];
    platforms = lib.platforms.unix;
  };
})
