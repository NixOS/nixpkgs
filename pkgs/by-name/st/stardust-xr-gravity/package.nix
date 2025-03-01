{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-gravity";
  version = "0-unstable-2024-12-29";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "gravity";
    rev = "eca5e835cd3abee69984ce6312610644801457a9";
    hash = "sha256-upw0MjGccSI1B10wabKPMGrEo7ATfg4a7Hzaucbf99w=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "color-rs-0.8.0" = "sha256-/p4wYiLryY0+h0HBJUo4OV2jdZpcVn2kqv+8XewM4gM=";
      "stardust-xr-0.45.0" = "sha256-1Bor53L+Fe18SU6MKwPLQXDGZq6E9++gtwDy4zkzZXw=";
    };
  };

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
