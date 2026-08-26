{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gotestdox";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "bitfield";
    repo = "gotestdox";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8zGCaxlyh98HVpuYLbL4wr1HqYB0XoEUdDyoJwkdPtk=";
  };

  vendorHash = "sha256-YPgT8atTGt4kWaPfC9KrINnDs8FFUPrYeBbw4Ybozqs=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for formatting Go test results as readable documentation";
    homepage = "https://github.com/bitfield/gotestdox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "gotestdox";
  };
})
