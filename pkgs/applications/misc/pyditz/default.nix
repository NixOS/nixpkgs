{ lib, pythonPackages }:

with pythonPackages;

let
  cerberus_1_1 = callPackage ./cerberus.nix { };
in buildPythonApplication rec {
  pname = "pyditz";
  version = "0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da0365ae9064e30c4a27526fb0d7a802fda5c8651cda6990d17be7ede89a2551";
  };
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ pyyaml six jinja2 cerberus_1_1 ];

  checkInputs = [ unittestCheckHook ];

  meta = with lib; {
    homepage = "https://pythonhosted.org/pyditz/";
    description = "Drop-in replacement for the Ditz distributed issue tracker";
    maintainers = [ maintainers.ilikeavocadoes ];
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
