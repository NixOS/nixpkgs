{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "0.3.0";
  name = "fava-${version}";

  src = fetchurl {
    url = "https://github.com/aumayr/fava/archive/v${version}.tar.gz";
    sha256 = "0jj4prv9f8h4zzynw006gvlg5m7ccwhrgrgdlklncpvb1rkarzjc";
  };

  buildInputs = with pythonPackages; [ flask ];

  meta = {
    homepage = https://github.com/aumayr/fava;
    description = "Web interface for beancount";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

