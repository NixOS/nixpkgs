{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "rcon-cli";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "itzg";
    repo = "rcon-cli";
    tag = finalAttrs.version;
    hash = "sha256-Cs2SYz6+3ziAbnoXiWdpwBg3lmIJWq06wuYy/TKoVSU=";
  };

  vendorHash = "sha256-MxIofF5Jj+w7gxsO+F48ymtgB3bgSutmC5Jh3GcKCnA=";
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
