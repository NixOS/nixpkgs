{
  lib,
  melpaBuild,
  lsp-bridge,
  yasnippet,
}:

melpaBuild {
  pname = "acm";
  inherit (lsp-bridge) version;

  inherit (lsp-bridge) src;

  packageRequires = [ yasnippet ];

  files = ''("acm/*.el" "acm/icons")'';

  meta = {
    description = "Asynchronous Completion Menu";
    homepage = "https://github.com/manateelazycat/lsp-bridge";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fxttr
      kira-bruneau
    ];
  };
}
