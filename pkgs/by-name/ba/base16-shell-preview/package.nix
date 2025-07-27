{
  lib,
  python3Packages,
  fetchPypi,
}:

let
  pname = "base16-shell-preview";
  version = "1.1.0";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "${lib.replaceStrings [ "-" ] [ "_" ] pname}";
    hash = "sha256-UWS1weiccSGqBU8grPAUKkuXb7qs5wliHVaPgdW4KtI=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  # If enabled, it will attempt to run '__init__.py, failing by trying to write
  # at "/homeless-shelter" as HOME
  doCheck = false;

  meta = {
    homepage = "https://github.com/nvllsvm/base16-shell-preview";
    description = "Browse and preview Base16 Shell themes in your terminal";
    mainProgram = "base16-shell-preview";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
