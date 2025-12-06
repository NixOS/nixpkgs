{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-flatland";
  version = "0.50.0-unstable-2025-12-01";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "flatland";
    rev = "77215fe4a69398b94d343f85d8925b1a49d470fc";
    hash = "sha256-mHcNh0Wm+VFYq0Ep+JdFDAcfEtr/pBoJ6tePcjXV2Co=";
  };

  env.STARDUST_RES_PREFIXES = "${src}/res";

  cargoHash = "sha256-kAF9ir/bOTTNYtIoMiYOU9uYlYtOZzmEUgEPJEVFDz8=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Flat window for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "flatland";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
