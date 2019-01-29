{ stdenv, python3Packages }:
with python3Packages; buildPythonApplication rec {
  pname = "pre_commit";
  version = "1.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kjrq8z78b6aqhyyw07dlwf6cqls88kik6f5l07hs71fj5ddvs9w";
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
