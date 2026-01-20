{
  lib,
  python3,
  fetchPypi,
}:

let
  inherit (python3.pkgs)
    buildPythonApplication
    pythonOlder
    ;
in
buildPythonApplication rec {
  pname = "dfmt";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7af6360ca8d556f1cfe82b97f03b8d1ea5a9d6de1fa3018290c844b6566d9d6e";
  };

  meta = {
    description = "Format paragraphs, comments and doc strings";
    mainProgram = "dfmt";
    homepage = "https://github.com/dmerejkowsky/dfmt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cole-h ];
  };
}
