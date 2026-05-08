{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "adidnsdump";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dirkjanm";
    repo = "adidnsdump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gKOIZuXYm8ltaajmOZXulPX5dI4fWz4xiZ8W0kPpcRk=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    impacket
    ldap3
  ];

  pythonImportsCheck = [ "adidnsdump" ];

  meta = {
    description = "Active Directory Integrated DNS dumping by any authenticated user";
    homepage = "https://github.com/dirkjanm/adidnsdump";
    changelog = "https://github.com/dirkjanm/adidnsdump/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "adidnsdump";
  };
})
