{
  lib,
  stdenv,
  fetchFromGitLab,
  installShellFiles,
  git,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.6.0";
  pname = "git-latexdiff";

  src = fetchFromGitLab {
    repo = "git-latexdiff";
    owner = "git-latexdiff";
    tag = finalAttrs.version;
    hash = "sha256-DMoGEbCBuqUGjbna3yDpD4WNTikPudYRD4Wy1pPG2mw=";
  };

  patches = [ ./version-test.patch ];

  postPatch = ''
    substituteInPlace git-latexdiff \
      --replace-fail "@GIT_LATEXDIFF_VERSION@" "v${finalAttrs.version}"
    patchShebangs git-latexdiff
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    git
    bash
  ];

  dontBuild = true;

  installPhase = ''
    installBin git-latexdiff
  '';

  meta = {
    description = "View diff on LaTeX source files on the generated PDF files";
    homepage = "https://gitlab.com/git-latexdiff/git-latexdiff";
    maintainers = with lib.maintainers; [ doronbehar ];
    license = lib.licenses.bsd3; # https://gitlab.com/git-latexdiff/git-latexdiff/issues/9
    platforms = lib.platforms.unix;
    mainProgram = "git-latexdiff";
  };
})
