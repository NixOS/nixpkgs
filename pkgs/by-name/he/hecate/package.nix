{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hecate";
  version = "unstable-2022-05-03";

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

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Terminal hex editor";
    longDescription = "The Hex Editor From Hell!";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ramkromberg ];
    mainProgram = "hecate";
  };
}
