{
  lib,
  buildGoModule,
  fetchFromSourcehut,
}:
buildGoModule {
  pname = "addr-book-combine";
  version = "2022-12-15";

  src = fetchFromSourcehut {
    owner = "~jcc";
    repo = "addr-book-combine";
    rev = "11696f4726b981c774ad1d4858f1a935ac71e9ac";
    hash = "sha256-SENur3p5LxMNnjo/+qiVdrEs+i+rI1PT1wYYdLLqWrg=";
  };

  vendorHash = null;

  meta = {
    description = "Combine multiple aerc-style address books into a single address book";
    homepage = "https://jasoncarloscox.com/creations/addr-book-combine/";
    license = lib.licenses.gpl3;
    mainProgram = "addr-book-combine";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
