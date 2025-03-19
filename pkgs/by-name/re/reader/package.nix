{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  self = buildGoModule {
    pname = "reader";
    version = "0.4.7";

    src = fetchFromGitHub {
      owner = "mrusme";
      repo = "reader";
      tag = "v${self.version}";
      hash = "sha256-Xg6ndfxKOfiIz654HcnhdvBGydOSSODBp8LnYxmqb4o=";
    };

    vendorHash = "sha256-dr/y4BBBe5K9U24ikLzYA+B2mzTGpFuFqoj5OLXtUG4=";

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
