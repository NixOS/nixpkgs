{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "memogram";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "usememos";
    repo = "telegram-integration";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q3C1Ehs2TMeKsnjcNiL4HK08sCeWXjqVHiE55iHs0g8=";
  };

  vendorHash = "sha256-3NdWhckcXUEeKLz2G7xsHlbIBViyvFDCQzNVvaDi48U=";

  subPackages = [ "bin/memogram" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy to use integration service for syncing messages and images from a Telegram bot into your Memos";
    homepage = "https://github.com/usememos/telegram-integration";
    changelog = "https://github.com/usememos/telegram-integration/releases/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ merrkry ];
    mainProgram = "memogram";
    platforms = lib.platforms.linux;
  };
})
