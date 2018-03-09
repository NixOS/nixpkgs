{python, html5}:

python.pkgs.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "xhtml2pdf";
  version = "0.2.1";

  buildInputs = [html5];
  propagatedBuildInputs = with python.pkgs; [httplib2 pillow pypdf2 reportlab html5];

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1n9r8zdk9gc2x539fq60bhszmd421ipj8g78zmsn3njvma1az9k1";
  };
}
