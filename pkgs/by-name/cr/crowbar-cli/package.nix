{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "crowbar-cli";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kushvinth";
    repo = "crowbar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hvHo/2SB5W+z9hUHrGWsEXn/+o98kzKIsN6ShYJtpd8=";
  };

  build-system = [ python3Packages.hatchling ];

  nativeCheckInputs = [
    python3Packages.unittestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "crowbar" ];

  meta = {
    description = "Offline vulnerability intelligence index (NVD, KEV, EPSS, Exploit-DB, OSV) with a CLI and MCP server";
    homepage = "https://github.com/kushvinth/crowbar";
    changelog = "https://github.com/kushvinth/crowbar/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kushvinth ];
    mainProgram = "crowbar";
  };
})
