{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dcnnt";
  version = "0.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-73ZLgb5YcXlAOjbKLVv8oqgS6pstBdJxa7LFUgIHpUE=";
  };

  propagatedBuildInputs = with python3Packages; [
    pycryptodome
  ];

  meta = {
    homepage = "https://github.com/cyanomiko/dcnnt-py";
    description = "UI-less tool to connect Android phone with desktop";
    longDescription = ''
      Yet another tool to connect Android phone with desktop similar to
      KDE Connect.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arnoutkroeze ];
    mainProgram = "dcnnt";
  };
})
