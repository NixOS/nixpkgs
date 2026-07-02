{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pwncat";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-x/h53zpYuuFTtzCEioiw4yTIt/jG2qFG5nz0WmxzYIg=";
  };

  build-system = with python3Packages; [ setuptools ];

  # Tests requires to start containers
  doCheck = false;

  meta = {
    description = "TCP/UDP communication suite";
    homepage = "https://pwncat.org/";
    changelog = "https://github.com/cytopia/pwncat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pwncat";
  };
})
