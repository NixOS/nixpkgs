{ stdenv, python3Packages }:
with python3Packages; buildPythonApplication rec {
  pname = "pre-commit";
  version = "1.15.2";

  src = fetchPypi {
    inherit version;
    pname = "pre_commit";
    sha256 = "1if44rfzmrw9m2k47kiplccby1lfdrlq82jlz4p91wwqc1vs4xi5";
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
    importlib-metadata
  ] ++ stdenv.lib.optional (pythonOlder "3.7") importlib-resources
    ++ stdenv.lib.optional (pythonOlder "3.2") futures;

  # Tests fail due to a missing windll dependency
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A framework for managing and maintaining multi-language pre-commit hooks";
    homepage = https://pre-commit.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ borisbabic ];
  };
}
