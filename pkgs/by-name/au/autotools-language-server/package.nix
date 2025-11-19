{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "autotools-language-server";
  version = "0.0.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "autotools-language-server";
    tag = version;
    hash = "sha256-cehiqxst3iGpR2UnkpN7wVAxd924n0ZNek3aiwEW+ZA=";
  };

  build-system = [
    python3.pkgs.setuptools-generate
    python3.pkgs.setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    tree-sitter-make
    lsp-tree-sitter
  ];
  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
  ];

  meta = with lib; {
    description = "Autotools language server, support configure.ac, Makefile.am, Makefile";
    homepage = "https://github.com/Freed-Wu/autotools-language-server";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "autotools-language-server";
  };
}
