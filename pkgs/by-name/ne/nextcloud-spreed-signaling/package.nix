{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nextcloud-spreed-signaling";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "nextcloud-spreed-signaling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WEA5sbQzcsnHGVeog3lZXF3/veJxw39rF1++ejS4aWA=";
  };

  vendorHash = "sha256-osxQW5nR37bLKHOuC7jAWNjSgJZy8KzWDgC2Mo36ovA=";

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
