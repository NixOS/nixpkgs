{
  lib,
  python3Packages,
  fetchFromGitHub,
  elfutils,
  nix-update-script,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "pystack";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "pystack";
    tag = "v${version}";
    hash = "sha256-CH15LDj7QegoTNn2GeJlF6C00E89WrKlgaclMMHcLi0=";
  };

  build-system = with python3Packages; [
    cython
    pkgconfig
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [ rich ];

  buildInputs = [ elfutils ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Print the stack trace of a running Python process, or of a Python core dump";
    homepage = "https://bloomberg.github.io/pystack/";
    downloadPage = "https://github.com/bloomberg/pystack";
    changelog = "https://github.com/bloomberg/pystack/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    platforms = lib.platforms.unix;
    mainProgram = "pystack";
  };
}
