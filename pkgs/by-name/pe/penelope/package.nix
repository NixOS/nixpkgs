{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "penelope";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brightio";
    repo = "penelope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ryUG/OQsU6mecr+kSe5CD41a53xNRrPs1esL+V1lmdQ=";
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
    changelog = "https://github.com/brightio/penelope/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "penelope.py";
    platforms = lib.platforms.all;
  };
})
