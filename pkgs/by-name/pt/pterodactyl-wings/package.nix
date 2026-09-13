{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "pterodactyl-wings";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-12nV7jFlVbjjZT3uFbYEhTyJcZe88FEQEguBkgcbHGI=";
  };

  vendorHash = "sha256-BtATik0egFk73SNhawbGnbuzjoZioGFWeA4gZOaofTI=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pterodactyl/wings/system.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Server control plane for Pterodactyl Panel";
    homepage = "https://pterodactyl.io";
    changelog = "https://github.com/pterodactyl/wings/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ padowyt2 ];
    mainProgram = "wings";
    platforms = lib.platforms.linux;
  };
})
