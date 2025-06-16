{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "rcon-cli";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "itzg";
    repo = "rcon-cli";
    tag = finalAttrs.version;
    hash = "sha256-1dexjVfbqTzq9RLhVPn0gRcdJTa/AFj8BiQLoD0/L5c=";
  };

  vendorHash = "sha256-xq1Z6cgUqXXVzc/j54Nul6xAXa5gKh3NeenQoMW+Xpg=";
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
