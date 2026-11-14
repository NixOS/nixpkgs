{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "adidnsdump";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dirkjanm";
    repo = "adidnsdump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9RUixcQ8l9EqHZQ3Hy+80AtLX+xZ7fdYcINMq7jCg70=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    impacket
    ldap3
    ldap3-ad-auth
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
