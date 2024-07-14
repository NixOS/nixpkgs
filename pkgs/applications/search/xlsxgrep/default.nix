{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "xlsxgrep";
  version = "0.0.23";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NRNqYzkv6KSyGljQn6dZ08tlJACQ6TRB7PWY7qINkQQ=";
  };

  pythonPath = with python3Packages; [ xlrd ];

  meta = with lib; {
    maintainers = with maintainers; [ felixscheinost ];
    description = "CLI tool to search text in XLSX and XLS files. It works similarly to Unix/GNU Linux grep";
    mainProgram = "xlsxgrep";
    homepage = "https://github.com/zazuum/xlsxgrep";
    license = licenses.mit;
  };
}
