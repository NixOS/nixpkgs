{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  nix-update-script,
}:
buildGoModule {
  pname = "addr-book-combine";
  version = "0-unstable-2022-12-14";

  src = fetchFromSourcehut {
    owner = "~jcc";
    repo = "addr-book-combine";
    rev = "11696f4726b981c774ad1d4858f1a935ac71e9ac";
    hash = "sha256-SENur3p5LxMNnjo/+qiVdrEs+i+rI1PT1wYYdLLqWrg=";
  };

  vendorHash = null;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Combine multiple aerc-style address books into a single address book";
    homepage = "https://jasoncarloscox.com/creations/addr-book-combine/";
    downloadPage = "https://git.sr.ht/~jcc/addr-book-combine";
    license = lib.licenses.gpl3Only;
    mainProgram = "addr-book-combine";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
