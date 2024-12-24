{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "penelope";
  version = "0.12.4-unstable-2024-10-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brightio";
    repo = "penelope";
    rev = "366534d192ed279cc822da565408ea7ff48d6a60";
    hash = "sha256-pBEYgLyicG34HsIBSt8P9xGJEaEz9ZWyxokNyuO6mdM=";
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
