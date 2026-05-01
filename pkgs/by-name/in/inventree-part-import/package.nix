{
  lib,
  python3Packages,
  fetchFromGitHub,

  # tests
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  inventree19 = python3Packages.inventree.overrideAttrs (_: {
    version = "0.19.0";
    src = fetchFromGitHub {
      owner = "inventree";
      repo = "inventree-python";
      tag = "0.19.0";
      hash = "sha256-38VGCFoJ7i+oB2LuqRwi5joe7Nd/VKlhWEZnZAg8z10=";
    };
  });
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "inventree-part-import";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "30350n";
    repo = "inventree-part-import";
    tag = finalAttrs.version;
    hash = "sha256-U/Jz5a4P2R/VeO97CIcm+JsQAhxuOzZeLX4TsbMnJps=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    browser-cookie3
    click
    cutie
    error-helper
    fake-useragent
    inventree19
    isocodes
    mouser
    platformdirs
    pyyaml
    requests
    requests-oauthlib
    tablib
    thefuzz
  ];

  pytestImportsCheck = [ "inventree_part_import" ];

  nativeCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
  ]);

  disabledTests = [
    # Requires access to inventree server
    "setup_categories"
  ];

  meta = {
    description = "CLI to import parts from suppliers like DigiKey, LCSC, Mouser, etc. to InvenTree";
    mainProgram = "inventree-part-import";
    homepage = "https://github.com/30350n/inventree-part-import";
    changelog = "https://github.com/30350n/inventree-part-import/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gigahawk
    ];
  };
})
