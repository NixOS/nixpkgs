{
  lib,
  fetchPypi,
  python3Packages,
  dmenu,
}:

python3Packages.buildPythonApplication rec {

  pname = "dmenu-extended";
  version = "1.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "dmenu_extended";
    inherit version;
    hash = "sha256-gO+HYs9I+naD4ZBLTnATWym4b7K0yWbFo4zOvvgYpjM=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = [
    python3Packages.setuptools
    dmenu
  ];

  meta = with lib; {
    description = "An extension to dmenu for quickly opening files and folders";
    homepage = "https://github.com/MarkHedleyJones/dmenu-extended";
    license = licenses.mit;
    maintainers = with maintainers; [ ByteSudoer ];
    mainProgram = "dmenu-extended";
    platforms = platforms.unix;
  };
}
