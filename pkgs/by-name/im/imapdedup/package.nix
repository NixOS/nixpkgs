{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "imapdedup";
  version = "1.5";
  pyproject = true;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "quentinsf";
    repo = "IMAPdedup";
    tag = finalAttrs.version;
    hash = "sha256-YpnBMyNPQ9ciJJCk+fK6+k7h330xWtEW3PzyydDYmPA=";
  };

  build-system = with python3Packages; [ hatchling ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "imapdedup" ];

  meta = {
    description = "Duplicate email message remover";
    homepage = "https://github.com/quentinsf/IMAPdedup";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.gpl2Only;
    changelog = "https://github.com/quentinsf/IMAPdedup/blob/${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "imapdedup";
  };
})
