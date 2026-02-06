{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "memogram";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "usememos";
    repo = "telegram-integration";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VYtH6r/2nPTBiAY9b3LDEAfgkiO4SaHAi7NkLg6sUrg=";
  };

  vendorHash = "sha256-6nJiB9LXF5QI4XJrcPDwwnG9CTmvyX7vf8X17lVuaZM=";

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
