{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "memogram";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "usememos";
    repo = "telegram-integration";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kXn3m7o+WqxONUUiy6PVfdJfKuo9hJfpaAaXQx0LsnU=";
  };

  vendorHash = "sha256-aSq+wjWZUK4Rh7bw9NqqxnD9H3X+EgMF6F4w+SUtm70=";

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
