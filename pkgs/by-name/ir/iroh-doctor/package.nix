{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iroh-doctor";
  version = "0.101.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh-doctor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bLOptu5Gw9bf0PIZ+9VImdclQJfezyW9FYDba3NMoIo=";
  };

  cargoHash = "sha256-iP5QOjv6YZWuXZJm+h94kNFIi9K1OH40+KdXsajxbU4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for testing iroh connectivity";
    homepage = "https://github.com/n0-computer/iroh-doctor";
    license = with lib.licenses; [
      asl20 # OR
      mit
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "iroh-doctor";
  };
})
