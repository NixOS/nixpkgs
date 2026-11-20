{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "smbcrawler";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SySS-Research";
    repo = "smbcrawler";
    tag = finalAttrs.version;
    hash = "sha256-xvoeD97mEadsRdBpZlsBXRnyAkWFu+ifFc7FV0tPNwU=";
  };

  build-system = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies =
    with python3.pkgs;
    [
      click
      impacket
      lxml
      markitdown
      peewee
      python-libnmap
      python-magic
      pyyaml
      xdg-base-dirs
      zundler
    ]
    ++ markitdown.optional-dependencies.all;

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "smbcrawler" ];

  disabledTests = [
    # Tests are container-based
    "test_base_guest_access"
    "test_full"
  ];

  meta = {
    description = "Tool that takes credentials and a list of hosts and crawls through shares";
    homepage = "https://github.com/SySS-Research/smbcrawler";
    changelog = "https://github.com/SySS-Research/smbcrawler/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "smbcrawler";
  };
})
