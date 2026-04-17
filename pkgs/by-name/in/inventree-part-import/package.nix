{
  lib,
  python312Packages,
  fetchPypi,
}:

python312Packages.buildPythonApplication (finalAttrs: {
  pname = "inventree_part_import";
  version = "1.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-wNokfkPgYncexFky7Q3uGGy12hgwbdrT1a1SMRND3oA=";
  };

  __structuredAttrs = true;

  build-system = with python312Packages; [ hatchling ];

  dependencies = with python312Packages; [
    cutie
    error-helper
    fake-useragent
    inventree
    isocodes
    mouser
    platformdirs
    pyyaml
    requests
    requests-oauthlib
    tablib
    thefuzz
    beautifulsoup4
    browser-cookie3
  ];

  meta = {
    changelog = "https://github.com/30350n/inventree-part-import/releases/tag/${finalAttrs.version}";
    description = "Automatically imports component data from suppliers into inventree";
    homepage = "https://github.com/30350n/inventree-part-import";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chordtoll ];
    mainProgram = "inventree-part-import";
  };
})
