{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "neo-cowsay";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "Code-Hex";
    repo = "Neo-cowsay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DmIjqBTIzwkQ8aJ6xCgIwjDtczlTH5AKbPKFUGx3qQ8=";
  };

  vendorHash = "sha256-gBURmodXkod4fukw6LWEY+MBxPcf4vn/f6K78UR77n0=";

  modRoot = "./cmd";

  doCheck = false;

  subPackages = [
    "cowsay"
    "cowthink"
  ];

  meta = {
    description = "Cowsay reborn, written in Go";
    homepage = "https://github.com/Code-Hex/Neo-cowsay";
    license = with lib.licenses; [
      artistic1 # or
      gpl3
    ];
    mainProgram = "cowsay";
  };
})
