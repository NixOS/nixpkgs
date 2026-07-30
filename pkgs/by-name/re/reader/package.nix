{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "reader";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "reader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R7U+atLrpx7ppdyMR381JUSOM7KAfDr8P9oEAzuZbCY=";
  };

  vendorHash = "sha256-XOcqyUGfE7tq1OY6h7WV33nBNgn+oLmKRSJfVKmXIz4=";

  meta = {
    description = "Lightweight tool offering better readability of web pages on the CLI";
    homepage = "https://github.com/mrusme/reader";
    changelog = "https://github.com/mrusme/reader/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "reader";
  };
})
