{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "c3-lsp";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "pherrymason";
    repo = "c3-lsp";
    rev = "v${version}";
    hash = "sha256-1EuDXQGzqNM19SRokM9GGzA2ZcD0XaCbywErVSjINIM=";
  };

  sourceRoot = "${src.name}/server";

  vendorHash = "sha256-7g0Z392ksrvV+D9nMw325BykwLd9mvXRS1Zv6RNSs0w=";

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
