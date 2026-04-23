{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "acpic";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version pname;
    hash = "sha256-vQ9VxCNbOmqHIY3e1wq1wNJl5ywfU2tm62gDg3vKvcg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pbr>=5.8.1,<6" "pbr"
  '';

  nativeBuildInputs = with python3Packages; [
    pbr
    setuptools
  ];

  # no tests
  doCheck = false;

  meta = {
    description = "Daemon extending acpid event handling capabilities";
    mainProgram = "acpic";
    homepage = "https://github.com/psliwka/acpic";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ aacebedo ];
  };
})
