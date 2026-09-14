{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "penelope";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brightio";
    repo = "penelope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pBC8qiZBPTwe7BLBLcAFPCb7Lu+7TzZoAzri160/un0=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Penelope Shell Handler";
    homepage = "https://github.com/brightio/penelope";
    changelog = "https://github.com/brightio/penelope/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "penelope";
    platforms = lib.platforms.all;
  };
})
