{
  lib,
  callPackage,
  f,
  markdown-mode,
  melpaBuild,
  nix-update-script,
  yasnippet,
}:

let
  lspce-module = callPackage ./module.nix { };
in
melpaBuild {
  pname = "lspce";
  inherit (lspce-module) version src meta;

  packageRequires = [
    f
    markdown-mode
    yasnippet
  ];

  # to compile lspce.el, it needs lspce-module.so
  files = ''(:defaults "${lib.getLib lspce-module}/lib/lspce-module.*")'';

  ignoreCompilationError = false;

  passthru = {
    inherit lspce-module;
    updateScript = nix-update-script {
      attrPath = "emacsPackages.lspce.lspce-module";
      extraArgs = [ "--version=branch" ];
    };
  };
}
