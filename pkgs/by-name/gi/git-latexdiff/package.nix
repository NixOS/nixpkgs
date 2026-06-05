{
  lib,
  stdenv,
  fetchFromGitLab,
  installShellFiles,
  asciidoc,
  makeBinaryWrapper,
  coreutils,
  gnused,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.7.1";
  pname = "git-latexdiff";

  src = fetchFromGitLab {
    repo = "git-latexdiff";
    owner = "git-latexdiff";
    tag = finalAttrs.version;
    hash = "sha256-ocEDds1vAnaj84YiAez150OZV82w3NlsgXoxNbUGW/Q=";
  };

  postPatch = ''
    substituteInPlace git-latexdiff \
      --replace-fail "@GIT_LATEXDIFF_VERSION@" "v${finalAttrs.version}"
    patchShebangs git-latexdiff
  '';

  nativeBuildInputs = [
    installShellFiles
    asciidoc
    makeBinaryWrapper
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  dontBuild = true;

  installPhase = ''
    installBin git-latexdiff
    wrapProgram ''${!outputBin}/bin/git-latexdiff \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnused
        ]
      }
    make git-latexdiff.1
    installManPage git-latexdiff.1
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
