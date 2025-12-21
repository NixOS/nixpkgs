{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pterodactyl-wings";
  version = "1.11.13";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UpYUHWM2J8nH+srdKSpFQEaPx2Rj2+YdphV8jJXcoBU=";
  };

  vendorHash = "sha256-eWfQE9cQ7zIkITWwnVu9Sf9vVFjkQih/ZW77d6p/Iw0=";
  doCheck = false;

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
