{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # dependencies
  setuptools,
}:

buildPythonPackage rec {
  pname = "cddlparser";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tidoust";
    repo = "cddlparser";
    tag = "v${version}";
    sha256 = "sha256-LcIxU77bYpsuE4j1QgzdD3d7CO/EUEA9xwn+uIV68Oc=";
  };

  build-system = [
    setuptools
  ];

  meta = {
    homepage = "https://github.com/tidoust/cddlparser";
    downloadPage = "https://github.com/tidoust/cddlparser/releases";
    description = "Concise data definition language (RFC 8610) parser implementation in Python";
    longDescription = ''
      A CDDL parser in Python

      Concise data definition language (RFC 8610) parser implementation in Python.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hemera ];
  };
}
