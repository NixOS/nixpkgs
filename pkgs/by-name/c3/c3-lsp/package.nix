{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "c3-lsp";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "pherrymason";
    repo = "c3-lsp";
    rev = "v${version}";
    hash = "sha256-HD3NE2L1ge0pf8vtrKkYh4GIZg6lSPTZGFQ+LPbDup4=";
  };

  sourceRoot = "${src.name}/server";

  vendorHash = "sha256-y+Qs3zuvTq/KRc1ziH0R7E10et+MaQW9xOsFmSdI7PM=";

  postInstall = ''
    mv $out/bin/lsp $out/bin/c3-lsp
  '';

  meta = {
    description = "Language Server for C3 Language";
    homepage = "https://github.com/pherrymason/c3-lsp";
    changelog = "https://github.com/pherrymason/c3-lsp/blob/${src.rev}/changelog.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "c3-lsp";
    platforms = lib.platforms.all;
  };
}
