{ lib, pythonPackages, fetchPypi }:

with pythonPackages;

buildPythonApplication rec {
  pname = "pyditz";
  version = "0.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2gNlrpBk4wxKJ1JvsNeoAv2lyGUc2mmQ0Xvn7eiaJVE=";
  };
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ pyyaml six jinja2 cerberus ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    homepage = "https://pypi.org/project/pyditz/";
    description = "Drop-in replacement for the Ditz distributed issue tracker";
    maintainers = [ maintainers.ilikeavocadoes ];
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
