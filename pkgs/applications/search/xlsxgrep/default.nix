{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "xlsxgrep";
  version = "0.0.23";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "014i1nifx67mxi0k9sch00j6bjykb6krzl2q3ara9s1g75inl4rm";
  };

  pythonPath = with python3Packages; [ xlrd ];

  meta = with lib; {
    maintainers = with maintainers; [ felixscheinost ];
    description = "CLI tool to search text in XLSX and XLS files. It works similarly to Unix/GNU Linux grep";
    homepage = "https://github.com/zazuum/xlsxgrep";
    license = licenses.mit;
  };
}
