{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "c3-lsp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "pherrymason";
    repo = "c3-lsp";
    rev = "v${version}";
    hash = "sha256-MScpFh4J4jVJI5WtW4tfNB18YDpxs+ass1HmXyOO5VM=";
  };

  sourceRoot = "${src.name}/server";

  vendorHash = "sha256-eT+Qirl0R1+di3JvXxggGK/nK9+nqw+8QEur+ldJXSc=";

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
