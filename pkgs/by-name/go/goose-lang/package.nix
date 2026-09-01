{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "goose-lang";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "goose-lang";
    repo = "goose";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LAuWd/KeVdvPY45wL8g0MBTMrRCHcu/Ti3+IUvtcFUY=";
  };

  vendorHash = "sha256-URRsbRWcupgKajK96NZYudFAjolFYD5nf+QeSkUw28w=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Goose converts a small subset of Go to Coq";
    homepage = "https://github.com/goose-lang/goose";
    changelog = "https://github.com/goose-lang/goose/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "goose";
  };
})
