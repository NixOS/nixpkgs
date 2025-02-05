{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "goose-lang";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "goose-lang";
    repo = "goose";
    rev = "v${version}";
    hash = "sha256-P26Q21MWrne1pB3/EvLYp2i8Xw7oG9Waer2hhHyco1A=";
  };

  vendorHash = "sha256-HCJ8v3TSv4UrkOsRuENWVz5Z7zQ1UsOygx0Mo7MELzY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Goose converts a small subset of Go to Coq";
    homepage = "https://github.com/goose-lang/goose";
    changelog = "https://github.com/goose-lang/goose/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "goose";
  };
}
