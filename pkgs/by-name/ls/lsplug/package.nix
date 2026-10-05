{
  lib,
  python3Packages,
  fetchFromSourcehut,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lsplug";
  version = "7";
  pyproject = true;

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "lsplug";
    tag = finalAttrs.version;
    hash = "sha256-eY9XNEdJfQREKroxsuPlv3CKqNX/XiMEnN8TdGYGa+g=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonImportsCheck = [
    "lsplug"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Replacement for lsusb that shows more useful info and less useless info";
    homepage = "https://git.sr.ht/~martijnbraam/lsplug";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      Luflosi
    ];
    mainProgram = "lsplug";
  };
})
