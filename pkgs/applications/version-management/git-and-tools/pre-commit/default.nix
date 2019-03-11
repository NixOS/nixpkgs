{ stdenv, python3Packages }:
with python3Packages; buildPythonApplication rec {
  pname = "pre-commit";
  version = "1.14.4";

  src = fetchPypi {
    inherit version;
    pname = "pre_commit";
    sha256 = "1ly40348x9lkzsr7a9grkn7m8m6lhfsv0ihlnp288xbvmrirrmnk";
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
