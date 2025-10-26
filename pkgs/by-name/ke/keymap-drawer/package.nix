{
  python3,
  fetchFromGitHub,
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      tree-sitter = super.tree-sitter.overrideAttrs {
        version = "0.24.0";
        src = fetchFromGitHub {
          owner = "tree-sitter";
          repo = "py-tree-sitter";
          tag = "v0.24.0";
          hash = "sha256-ZDt/8suteaAjGdk71l8eej7jDkkVpVDBIZS63SA8tsU=";
          fetchSubmodules = true;
        };
        # keymap-drawer only requires tree-sitter-devicetree grammer, and
        # the tests fail with numereous TREE_SITTER_LANGUAGE_VERSION
        # related failures related to other grammers. Hence we disable the
        # tests altogether, hoping that in the future this python3.override
        # won't be needed at all.
        doInstallCheck = false;
      };
    };
  };
in
python.pkgs.toPythonApplication python.pkgs.keymap-drawer
