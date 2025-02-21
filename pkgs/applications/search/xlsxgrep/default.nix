{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "xlsxgrep";
  version = "0.0.29";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vgHNu7MVDjULoBiTkk74W8ZLJ02eds60XshTX3iLJGI=";
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
