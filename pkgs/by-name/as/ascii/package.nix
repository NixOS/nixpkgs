{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  asciidoctor,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ascii";
  version = "3.32";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "ascii";
    tag = finalAttrs.version;
    hash = "sha256-dqleZdqJIjwUy6Ky0329iLfYSluAgHs68LHgLkQcu5Y=";
  };

  nativeBuildInputs = [
    asciidoctor
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Interactive ASCII name and synonym chart";
    mainProgram = "ascii";
    homepage = "http://www.catb.org/~esr/ascii/";
    changelog = "https://gitlab.com/esr/ascii/-/blob/${finalAttrs.version}/NEWS.adoc";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
