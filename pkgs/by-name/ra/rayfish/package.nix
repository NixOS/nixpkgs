{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rayfish";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rayfish";
    repo = "rayfish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YIkx0Vlc620x9SS1tFdJMF1RRXTebgSMxa9p7PfdrvM=";
  };

  cargoHash = "sha256-l5hH/r8bScDCbcB8nIMlcVlfa+0P4Z9v3yXtdZ2Zj+g=";

  __darwinAllowLocalNetworking = true;

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
