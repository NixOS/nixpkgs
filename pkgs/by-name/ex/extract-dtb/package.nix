{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "extract-dtb";
  version = "1.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g8Dadd0YwE5c/z6Bh/hIGtHsbmoGsgvAQjE/Hfl2+ag=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  meta = {
    description = "Extract device tree blobs (dtb) from kernel images";
    homepage = "https://github.com/PabloCastellano/extract-dtb";
    changelog = "https://github.com/PabloCastellano/extract-dtb/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "extract-dtb";
  };
}
