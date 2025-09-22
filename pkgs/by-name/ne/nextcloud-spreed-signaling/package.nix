{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nextcloud-spreed-signaling";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "nextcloud-spreed-signaling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-im6P76g1OMHoHZAHGFBA+urcdmokWKxmuhPJac2Lz/Y=";
  };

  vendorHash = "sha256-zfX4rh1moMVxzeMxsLVlefgUxwzH0MMLxMFbA3qv6hU=";

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
