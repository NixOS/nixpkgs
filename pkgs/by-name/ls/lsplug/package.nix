{
  lib,
  python3Packages,
  fetchFromSourcehut,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lsplug";
  version = "235c5386a85559bbc050508354f45f9fd8be50a9";
  pyproject = true;

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "lsplug";
    tag = finalAttrs.version;
    hash = "sha256-L3McMLAjiuWbyXdaij5FZq5M7z+rP4RVzg83hBkxOWk=";
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
