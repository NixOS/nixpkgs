{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "penelope";
  version = "0.14.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brightio";
    repo = "penelope";
    tag = "v${version}";
    hash = "sha256-m4EYP1lKte8r9Xa/xAuv6aiwMNha+B8HXUCizH0JgmI=";
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
