{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "penelope";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brightio";
    repo = "penelope";
    tag = "v${version}";
    hash = "sha256-paVKCqR8J1bINz80qOBqiG2wxGjiJlf0gv3LIyS/Xs0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "[project.scripts]" "" \
      --replace-fail 'penelope = "penelope:main"' ""
  '';

  build-system = with python3.pkgs; [ setuptools ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Penelope Shell Handler";
    homepage = "https://github.com/brightio/penelope";
    changelog = "https://github.com/brightio/penelope/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "penelope.py";
    platforms = lib.platforms.all;
  };
}
