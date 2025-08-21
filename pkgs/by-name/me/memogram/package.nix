{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "memogram";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "usememos";
    repo = "telegram-integration";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yQmdUphgGr/db2FJ5tghUhjWt7QGs0mCAI/NrBNRABk=";
  };

  vendorHash = "sha256-8tQ5MQ0XcBIx74EFAXxXInADFd4BnlTazeIFNXNN/Ww=";

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
