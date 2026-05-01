{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "seashells";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-RBs28FC7f82DrxRcmvTP9nljVpm7tjrGuvr05l32hDM=";
  };

  build-system = with python3Packages; [ setuptools ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "seashells" ];

  meta = {
    homepage = "https://seashells.io/";
    description = "Pipe command-line programs to seashells.io";
    mainProgram = "seashells";
    longDescription = ''
      Official cient for seashells.io, which allows you to view
      command-line output on the web, in real-time.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ deejayem ];
  };
})
