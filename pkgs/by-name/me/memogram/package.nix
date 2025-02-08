{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "memogram";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "usememos";
    repo = "telegram-integration";
    tag = "v${version}";
    hash = "sha256-CUo5fPWNE4FP1Dtwb1rPNSPP/CAJvYGYYIMAx/oeSOc=";
  };

  vendorHash = "sha256-BDGA7GpXS3/esBvb3+rC8ZgtER2OgBJ1bHZ6AHP/i4s=";

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
