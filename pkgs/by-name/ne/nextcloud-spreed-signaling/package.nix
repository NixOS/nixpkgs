{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  name = "nextcloud-spreed-signaling";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "nextcloud-spreed-signaling";
    tag = "v${version}";
    hash = "sha256-DaB3pCis11zpSIGb3DjDVlJQhIxZBGB1Z+YvvrmXy8o=";
  };

  vendorHash = "sha256-YHGzQWTGdFzwFfOppH6OSjzAXS4GTgrEMb2z0POtwuM=";

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dedicated signaling backend for nextcloud talk";
    homepage = "https://github.com/strukturag/nextcloud-spreed-signaling";
    downloadPage = "https://github.com/strukturag/nextcloud-spreed-signaling/releases/tag/v${version}";
    changelog = "https://github.com/strukturag/nextcloud-spreed-signaling/releases/tag/v${version}";
    mainProgram = "server";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      hensoko
    ];
    platforms = [ "x86_64-linux" ];
  };
}
