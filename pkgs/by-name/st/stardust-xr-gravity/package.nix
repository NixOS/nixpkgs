{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "stardust-xr-gravity";
  version = "0.50.0-unstable-2025-11-29";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "gravity";
    rev = "3283bf8b352cdcb04ef3e0edb5155c4ca8c5c97c";
    hash = "sha256-oTFcwCpugMImWX+4C2OW1inrlQahMqd3n/0TiWKrjFQ=";
  };

  cargoHash = "sha256-vV8/WtAGWDIiUOGNZcK91SJ5M6aFBEPi6/k0I1MO/bI=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Utility to launch apps and stardust clients at an offet";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "gravity";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
