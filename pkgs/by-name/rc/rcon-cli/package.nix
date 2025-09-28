{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "rcon-cli";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "itzg";
    repo = "rcon-cli";
    tag = finalAttrs.version;
    hash = "sha256-wog4nnXITV5p2lzfuO9tB//B87nh8KGpsCfSalt8WvE=";
  };

  vendorHash = "sha256-vD+i3vMInErO0MpIRgsVe0Fl6HuFIwUS8xKHdZ7lxVM=";
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
