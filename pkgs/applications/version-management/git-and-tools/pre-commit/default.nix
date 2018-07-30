{ stdenv, python3Packages }:
with python3Packages; buildPythonApplication rec {
  pname = "pre_commit";
  version = "1.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kn8h9k9ca330m5n7r4cvxp679y3sc95m1x23a3qhzgam09n7jwr";
  };

  propagatedBuildInputs = [
    aspy-yaml
    cached-property
    cfgv
    identify
    nodeenv
    six
    toml
    virtualenv
  ];

  # Tests fail due to a missing windll dependency
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A framework for managing and maintaining multi-language pre-commit hooks";
    homepage = https://pre-commit.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ borisbabic ];
  };
}
