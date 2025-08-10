{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nextcloud-spreed-signaling";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "nextcloud-spreed-signaling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JBYhmIXDpovkXM8oYO3B9n2bs+H0GjmuT4Dl3gEQjPo=";
  };

  vendorHash = "sha256-MGz0tj6QwDXYDtamgN6d5yfIFHToE+XF3HYVsFRxHhM=";

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dedicated signaling backend for nextcloud talk";
    homepage = "https://github.com/strukturag/nextcloud-spreed-signaling";
    downloadPage = "https://github.com/strukturag/nextcloud-spreed-signaling/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/strukturag/nextcloud-spreed-signaling/releases/tag/v${finalAttrs.version}";
    mainProgram = "server";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      hensoko
    ];
    platforms = [ "x86_64-linux" ];
  };
})
