{
  lib,
  stdenv,
  fetchFromGitLab,
  ncurses,
  asciidoctor,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "greed";
  version = "4.3";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "greed";
    tag = finalAttrs.version;
    hash = "sha256-NmX0hYHODe55N0edhdfdm0a/Yqm/UwkU/RREjYl3ePc=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "-lcurses" "-lncurses" \
      --replace-fail "BIN=/usr/games" "BIN=$out/bin" \
      --replace-fail "/usr/share" "$out/share" \
      --replace-fail "/usr/games/lib/greed.hs" "/var/lib/greed/greed.hs"
  '';

  buildInputs = [
    ncurses
  ];

  nativeBuildInputs = [
    asciidoctor
  ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man6
  '';

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    homepage = "http://www.catb.org/~esr/";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    description = "Game of Consumption";
    changelog = "https://gitlab.com/esr/greed/-/blob/${finalAttrs.version}/NEWS.adoc?ref_type=tags";
    mainProgram = "greed";
  };
})
