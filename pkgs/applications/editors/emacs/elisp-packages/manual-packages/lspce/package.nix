{
  lib,
  f,
  lspce-module,
  markdown-mode,
  melpaBuild,
  yasnippet,
}:

melpaBuild {
  pname = "lspce";
  inherit (lspce-module) version src meta;

  packageRequires = [
    f
    markdown-mode
    yasnippet
  ];

  # lspce-module.so is needed to compile lspce.el
  files = ''(:defaults "${lib.getLib lspce-module}/lib/lspce-module.*")'';

  passthru = {
    inherit lspce-module;
  };
}
