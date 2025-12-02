{
  lib,
  python3Packages,
  fetchFromGitHub,
  libkrb5,
  versionCheckHook,
  nix-update-script,
  enableKerberos ? true,
}:

python3Packages.buildPythonApplication rec {
  pname = "evil-winrm-py";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adityatelange";
    repo = "evil-winrm-py";
    tag = "v${version}";
    hash = "sha256-IACFPPlkgyJh78p6Jy740CQqcySkMTV/8VVPSRJKTPI=";
  };

  # Removes the additional binary ewp
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"ewp = evil_winrm_py.evil_winrm_py:main",' ""
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies =
    with python3Packages;
    [
      pypsrp
      prompt-toolkit
      tqdm
    ]
    ++ lib.optionals enableKerberos pypsrp.optional-dependencies.kerberos;

  # Add the C library if Kerberos is enabled
  buildInputs = lib.optionals enableKerberos [ libkrb5 ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Execute commands interactively on remote Windows machines using the WinRM protocol";
    homepage = "https://github.com/adityatelange/evil-winrm-py";
    changelog = "https://github.com/adityatelange/evil-winrm-py/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ letgamer ];
    mainProgram = "evil-winrm-py";
  };
}
