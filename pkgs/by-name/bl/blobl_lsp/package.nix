{
  lib,
  buildGo127Module,
  fetchFromCodeberg,
  nix-update-script,
}:

# buildGo127Module: default `go` (1.26) is older than go.mod's `go 1.27.1`.
buildGo127Module (finalAttrs: {
  pname = "blobl_lsp";
  version = "0.7.0";

  src = fetchFromCodeberg {
    owner = "hsctech";
    repo = "blobl_lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-znnCmcbK3OCEzEotzfbqJxDcrSewmcBXfsjyTLwvKew=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-wUHC7ebhY5QQ4UJq183ftN821skKXxu3jitvxEm30Ns=";

  passthru.updateScript = nix-update-script { };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Language server for Bento's Bloblang mapping language";
    homepage = "https://codeberg.org/hsctech/blobl_lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ henrikschristensen ];
    mainProgram = "blobl_lsp";
    platforms = lib.platforms.all;
  };
})
