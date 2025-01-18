{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-sphereland";
  version = "0-unstable-2023-11-07";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "sphereland";
    rev = "39552d918c99a84eaf5f2d5e8734a472bf196f65";
    hash = "sha256-LKdqTl14cdgD14IwAP34mWdDgREhy1CHOT86HywOxqM=";
  };

  env.STARDUST_RES_PREFIXES = "${src}/res";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "stardust-xr-0.14.1" = "sha256-aJYovCKcR6zoqsVenCBnL5a/ccvXxNku+mAKRf0pp1Q=";
      "stardust-xr-molecules-0.29.0" = "sha256-rzbLqx+X8KEjut6Cq4x/qiSN9OfbMemrDUP0F+hXy4U=";
    };
  };
  buildInputs = [
    libxkbcommon
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "Pointer/keyboard operated window manager for Stardust XR";
    homepage = "https://stardustxr.org";
    license = licenses.mit;
    mainProgram = "sphereland";
    maintainers = with maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = platforms.linux;
  };
}
