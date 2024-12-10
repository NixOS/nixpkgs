{
  lib,
  melpaBuild,
  lsp-bridge,
  yasnippet,
  writeText,
}:

melpaBuild {
  pname = "acm";
  version = lsp-bridge.version;

  src = lsp-bridge.src;
  commit = lsp-bridge.src.rev;

  packageRequires = [
    yasnippet
  ];

  recipe = writeText "recipe" ''
    (acm
      :repo "manateelazycat/lsp-bridge"
      :fetcher github
      :files ("acm/*.el" "acm/icons"))
  '';

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
