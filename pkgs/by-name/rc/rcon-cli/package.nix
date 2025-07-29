{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "rcon-cli";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "itzg";
    repo = "rcon-cli";
    tag = finalAttrs.version;
    hash = "sha256-72wlcQ57OuFS8CWIDMavdFGy5jWlBbzIjgdqeP7fbg0=";
  };

  vendorHash = "sha256-RX3tCZID9xS4zHQYGyAarmI2jbUwZEFWzo0lh7h3f1s=";
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
