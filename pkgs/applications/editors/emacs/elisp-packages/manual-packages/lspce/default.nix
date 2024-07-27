{
  lib,
  f,
  markdown-mode,
  melpaBuild,
  nix-update-script,
  yasnippet,
  # put lspce-module here so that users can override it
  lspce-module,
}:

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

  passthru = {
    inherit lspce-module;
    updateScript = nix-update-script {
      attrPath = "emacsPackages.lspce.lspce-module";
      extraArgs = [ "--version=branch" ];
    };
  };
}
