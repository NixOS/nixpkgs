{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "beancount-ing-diba";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "siddhantgoel";
    repo = "beancount-ing-diba";
    rev = "v${version}";
    sha256 = "sha256-1cdXqdeTz38n0g13EXJ1/IF/gJJCe1uL/Z5NJz4DL+E=";
  };

  patches = [
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/siddhantgoel/beancount-ing/commit/2d030330eed313a32c3968a2c8ce9400c6d18a41.patch";
      hash = "sha256-6v7eQhgj6d4x9uWSyuO3IxXrSWkJZRS/M4N3j0H3R/U=";
    })
  ];

  format = "pyproject";

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  meta = with lib; {
    homepage = "https://github.com/siddhantgoel/beancount-ing-diba";
    description = "Beancount Importers for ING-DiBa (Germany) CSV Exports";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
