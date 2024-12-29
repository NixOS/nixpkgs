{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "pyditz";
  version = "0.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2gNlrpBk4wxKJ1JvsNeoAv2lyGUc2mmQ0Xvn7eiaJVE=";
  };

  build-system = with python3Packages; [ setuptools-scm ];

  dependencies = with python3Packages; [
    pyyaml
    six
    jinja2
    cerberus
  ];

  meta = {
    homepage = "https://hg.sr.ht/~zondo/pyditz";
    description = "Drop-in replacement for the Ditz distributed issue tracker";
    maintainers = with lib.maintainers; [ ilikeavocadoes ];
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
}
