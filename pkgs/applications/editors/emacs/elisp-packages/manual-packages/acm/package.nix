{
  lib,
  melpaBuild,
  lsp-bridge,
  yasnippet,
}:

melpaBuild {
  pname = "acm";
  version = lsp-bridge.version;

  src = lsp-bridge.src;

  packageRequires = [ yasnippet ];

  files = ''("acm/*.el" "acm/icons")'';

  ignoreCompilationError = false;

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
