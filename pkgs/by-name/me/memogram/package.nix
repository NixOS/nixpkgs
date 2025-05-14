{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "memogram";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "usememos";
    repo = "telegram-integration";
    tag = "v${version}";
    hash = "sha256-nhNVo8Bp/g/IWyj548BQlyxPy1t3DDCyLmInDwQCH4c=";
  };

  vendorHash = "sha256-g8mAG5l2juOVaem2xk+pPVzKYNJHbWbkS/D0LwF+XdM=";

  subPackages = [ "bin/memogram" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy to use integration service for syncing messages and images from a Telegram bot into your Memos";
    homepage = "https://github.com/usememos/telegram-integration";
    changelog = "https://github.com/usememos/telegram-integration/releases/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ merrkry ];
    mainProgram = "memogram";
    platforms = lib.platforms.linux;
  };
}
