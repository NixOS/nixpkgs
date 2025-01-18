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

  meta = with lib; {
    description = "Asynchronous Completion Menu";
    homepage = "https://github.com/manateelazycat/lsp-bridge";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      fxttr
      kira-bruneau
    ];
  };
}
