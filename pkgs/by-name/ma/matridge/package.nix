{
  lib,
  python3Packages,
  fetchFromCodeberg,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "matridge";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "slidge";
    repo = "matridge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yc4MT8MBizHJylIFJeC+rKf31IBRQVptaok8L6f3w98=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    (matrix-nio.override { withOlm = true; })
    beautifulsoup4
    async-lru
    slidge-style-parser
    slidge
  ];

  meta = {
    changelog = "https://codeberg.org/slidge/matridge/releases/tag/v${finalAttrs.version}";
    description = "Matrix to XMPP gateway";
    homepage = "https://slidge.im/docs/matridge/main/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ haansn08 ];
    platforms = lib.platforms.all;
    mainProgram = "matridge";
  };

  __structuredAttrs = true;
})
