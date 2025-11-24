{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "rcon-cli";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "itzg";
    repo = "rcon-cli";
    tag = finalAttrs.version;
    hash = "sha256-v9f367XTPKAocGdwwPe/dXsFK30THbqpQwuvSV/lWN4=";
  };

  vendorHash = "sha256-TogEdy0rtOzywBCtJ9dw8jO25dzxygqDGFDCbCNwhz8=";
  subPackages = [ "." ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Little RCON cli based on james4k's RCON library for golang";
    homepage = "https://github.com/itzg/rcon-cli";
    changelog = "https://github.com/itzg/rcon-cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      link00000000
    ];
    mainProgram = "rcon-cli";
  };
})
