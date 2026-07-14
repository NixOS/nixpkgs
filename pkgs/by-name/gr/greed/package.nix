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
  version = "4.5";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "greed";
    tag = finalAttrs.version;
    hash = "sha256-S2K6nn4WS1gOvhlYK/UH1hfA0pzij4w5SeP004WVZik=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "-lcurses" "-lncurses" \
      --replace-fail "/usr/games/lib/greed.hs" "/var/lib/greed/greed.hs"
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    ncurses
  ];

  nativeBuildInputs = [
    asciidoctor
  ];

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
