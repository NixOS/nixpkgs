{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unstableGitUpdater,
  poetry-core,
  nixops,
}:

buildPythonPackage {
  pname = "nixops-hercules-ci";
  version = "0-unstable-2021-10-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hercules-ci";
    repo = "nixops-hercules-ci";
    rev = "e601d5baffd003fd5f22deeaea0cb96444b054dc";
    hash = "sha256-4IZ+qzhERJIhLcIq9FvVml+xAFJ8R4QpUjFRw2DZl2U=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    nixops
  ];

  pythonImportsCheck = [ "nixops_hercules_ci" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Use Hercules CI as a NixOps backend";
    homepage = "https://github.com/hercules-ci/nixops-hercules-ci";
    license = licenses.asl20;
    maintainers = with maintainers; [ roberth ];
  };
}
