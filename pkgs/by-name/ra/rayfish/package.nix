{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rayfish";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rayfish";
    repo = "rayfish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y9XQt6HhGWXI7Uwpw4TjqMavqEE/+pa0gEhQ0Gh/SqM=";
  };

  cargoHash = "sha256-mh4lGbI3GUH32vf0FwVqyh737gCM7nEphQJr1rQed48=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "P2P mesh VPN powered by iroh";
    longDescription = ''
      Rayfish is a peer-to-peer mesh VPN that lets your laptop, phone, server, and
      your friends' machines talk to each other as if they were all plugged into the
      same router, even when they're scattered across the world behind different NATs.
    '';
    homepage = "https://rayfish.xyz";
    changelog = "https://github.com/rayfish/rayfish/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "rayfish";
  };
})
