{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
  versionCheckHook,
}:

python3Packages.buildPythonApplication {
  pname = "ntlm_theft";
  version = "0-unstable-2026-09-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Greenwolf";
    repo = "ntlm_theft";
    rev = "7ef7fb5cda5cc3b03d512f2a9bc4d17bb93d0656";
    hash = "sha256-va1qDfQ0s1/VsZc9xCIqGBfI3EGl+sfYTvYDnJqFe+0=";
  };

  __structuredAttrs = true;

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    xlsxwriter
  ];

  postPatch = ''
    # Fix file permissions as copytree normally inherits the ro permissions from the nix store which leads to unwriteable files
    sed -i '/import shutil/a shutil.copystat = lambda *args, **kwargs: None' ntlm_theft.py
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  preVersionCheck = "export version=0.1.0";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Tool for generating multiple types of NTLMv2 hash theft files";
    homepage = "https://github.com/Greenwolf/ntlm_theft";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ letgamer ];
    mainProgram = "ntlm_theft";
    platforms = lib.platforms.all;
  };
}
