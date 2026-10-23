{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hecate";
  version = "0.0.1-unstable-2022-05-02";

  src = fetchFromGitHub {
    owner = "evanmiller";
    repo = "hecate";
    rev = "7637250f4b2c5b777418b35fa11276d11d5128b0";
    sha256 = "sha256-8L0ukzPF7aECCeZfwZYKcJAJLpPgotkVJ+OSdwQUjhw=";
  };

  vendorHash = "sha256-eyMrTrNarNCB3w8EOeJBmCbVxpMZy25sQ19icVARU1M=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Terminal hex editor";
    longDescription = "The Hex Editor From Hell!";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ramkromberg ];
    mainProgram = "hecate";
  };
})
