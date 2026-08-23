{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gladtex";
  version = "4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "humenda";
    repo = "GladTeX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z8DZxQRLibEHdMAR8S4Gz1rwBqXXwkd25scUNbBHs2g=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  meta = {
    description = "Embed LaTeX formulas into HTML documents as SVG images";
    mainProgram = "gladtex";
    homepage = "https://humenda.github.io/GladTeX";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pentane ];
  };
})
