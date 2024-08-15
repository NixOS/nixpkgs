{ lib
, python311
, fetchFromGitHub
, fetchpatch
}:

let
  python3 = python311.override {
    self = python3;
    packageOverrides = _: super: { tree-sitter = super.tree-sitter_0_21; };
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "autotools-language-server";
  version = "0.0.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "autotools-language-server";
    rev = "refs/tags/${version}";
    hash = "sha256-V0EOV1ZmeC+4svc2fqV6AIiL37dkrxUJAnjywMZcENw=";
  };
  patches = [
    # Right before the release, upstream decided to replace the
    # tree-sitter-languages dependency with tree-sitter-make, which is yanked
    # from some reason. Hopefully upstream will fix this dependency a bit
    # better in the next release. See also:
    # https://github.com/Freed-Wu/autotools-language-server/commit/f149843becfcfd6b2bb4a98eb1f3984c01d5fd33#r142659163
    (fetchpatch {
      url = "https://github.com/Freed-Wu/autotools-language-server/commit/f149843becfcfd6b2bb4a98eb1f3984c01d5fd33.patch";
      hash = "sha256-TrzHbfR6GYAEqDIFiCqSX2+Qv4JeFJ5faiKJhNYojf0=";
      revert = true;
    })
  ];

  build-system = [
    python3.pkgs.setuptools-generate
    python3.pkgs.setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    tree-sitter-languages
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
