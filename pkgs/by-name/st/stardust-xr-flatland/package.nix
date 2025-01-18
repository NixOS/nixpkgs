{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-flatland";
  version = "0-unstable-2024-04-13";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "flatland";
    rev = "b3b0f29c4ea1b82c96cf9de507837bf15a5e4c0e";
    hash = "sha256-m7c6XpmpTM1URuqMG2KqtaWbL2Vt8vJFJtmvq123BmY=";
  };

  env.STARDUST_RES_PREFIXES = "${src}/res";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "stardust-xr-0.44.0" = "sha256-Gu/P78nFFVSpgwCcbMwyoqdEZO8zIcvP1ovU7Y0sXqg=";
      "stardust-xr-molecules-0.44.0" = "sha256-TpgsmQnaAbtcp+veclGaht7f9hwEWEzMOpEIvdICTbc=";
    };
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "A flat window for Stardust XR";
    homepage = "https://stardustxr.org";
    license = licenses.mit;
    mainProgram = "flatland";
    maintainers = with maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = platforms.linux;
  };
}
