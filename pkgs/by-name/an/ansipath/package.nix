{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ansipath";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "averyfreeman";
    repo = "ansipath";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0BIkl1uM/WYm/xUUL1le+Lv3QGPg3/n9F1bav4Ux1nc=";
  };

  build-system = [ python3Packages.hatchling ];

  pythonImportsCheck = [ "ansipath" ];

  meta = {
    description = "A colorized diagnostic view of shell PATH entries";
    homepage = "https://github.com/averyfreeman/ansipath";
    changelog = "https://github.com/averyfreeman/ansipath/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "ansipath";
    platforms = lib.platforms.unix;
  };
})
