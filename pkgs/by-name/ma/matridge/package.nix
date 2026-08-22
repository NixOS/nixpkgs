{
  lib,
  python3Packages,
  fetchFromCodeberg,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "matridge";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "slidge";
    repo = "matridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OOyAMIsTEesuBdY35UTWru5mPkIKgeX8BZvpfz8PHbM=";
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

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = {
    changelog = "https://codeberg.org/slidge/matridge/releases/tag/${finalAttrs.src.tag}";
    description = "Matrix to XMPP gateway";
    homepage = "https://slidge.im/docs/matridge/main/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ haansn08 ];
    platforms = lib.platforms.all;
    mainProgram = "matridge";
  };
})
