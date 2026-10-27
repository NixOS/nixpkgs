{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "getsploit";
  version = "3.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vulnersCom";
    repo = "getsploit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7rmSy5byVFYa8SPmdzS+eux6IPEgxKp3VOXOQGgCRjU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.29,<0.12" "uv_build"
  '';

  pythonRelaxDeps = [ "rich" ];

  build-system = with python3Packages; [ uv-build ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  dependencies = with python3Packages; [
    click
    detect-secrets
    rich
    vulners
  ];

  doInstallCheck = true;

  pythonImportsCheck = [ "getsploit" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Search and download public exploits from the Vulners database";
    homepage = "https://github.com/vulnersCom/getsploit";
    changelog = "https://github.com/vulnersCom/getsploit/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "getsploit";
  };
})
