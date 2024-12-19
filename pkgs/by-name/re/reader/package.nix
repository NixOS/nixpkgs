{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  self = buildGoModule {
    pname = "reader";
    version = "0.4.5";

    src = fetchFromGitHub {
      owner = "mrusme";
      repo = "reader";
      rev = "v${self.version}";
      hash = "sha256-9hZ7ZS+p6PoLKcuHS2re537wxojN2SzhOm5gBuRX9Xc=";
    };

    vendorHash = "sha256-obYdifg3WrTyxgN/VtzgpL31ZOyPNtVT8UDQts0WodQ=";

    meta = {
      description = "Lightweight tool offering better readability of web pages on the CLI";
      homepage = "https://github.com/mrusme/reader";
      changelog = "https://github.com/mrusme/reader/releases";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ theobori ];
      mainProgram = "reader";
    };
  };
in
self
