{
  lib,
  stdenv,
  fetchFromGitLab,
  python3Packages,
  texinfo,
}:

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication (finalAttrs: {
  pname = "rubber";
  version = "1.6.6";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "latex-rubber";
    repo = "rubber";
    rev = finalAttrs.version;
    hash = "sha256-C26PN3jyV6qwSjgPem54bykZrpKj+n8iHYYUyR+8dgI=";
  };

  postPatch = ''
    sed -i -e '/texi2dvi/d' hatch_build.py

    substituteInPlace tests/run.sh \
      --replace-fail /var/tmp /tmp
  '';

  nativeBuildInputs = [
    pypkgs.hatchling
    texinfo
  ];

  checkPhase = ''
    runHook preCheck

    pushd tests >/dev/null
    ${stdenv.shell} run.sh
    popd >/dev/null

    runHook postCheck
  '';

  meta = {
    description = "Wrapper for LaTeX and friends";
    longDescription = ''
      Rubber is a program whose purpose is to handle all tasks related
      to the compilation of LaTeX documents.  This includes compiling
      the document itself, of course, enough times so that all
      references are defined, and running BibTeX to manage
      bibliographic references.  Automatic execution of dvips to
      produce PostScript documents is also included, as well as usage
      of pdfLaTeX to produce PDF documents.
    '';
    license = lib.licenses.gpl2Plus;
    homepage = "https://gitlab.com/latex-rubber/rubber";
    maintainers = with lib.maintainers; [
      ttuegel
      peterhoeg
    ];
    platforms = lib.platforms.unix;
    mainProgram = "rubber";
  };
})
