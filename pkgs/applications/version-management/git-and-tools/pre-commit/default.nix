{ stdenv, python3Packages }:
with python3Packages; buildPythonApplication rec {
  pname = "pre_commit";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03nxkma8qp5j2bg6ailclnyqfhakp8r8d1mn6zcnjw0ac5r9imc8";
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
