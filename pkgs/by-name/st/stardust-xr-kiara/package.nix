{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  niri,
  stardust-xr-kiara,
  testers,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-kiara";
  version = "0-unstable-2024-07-13";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "kiara";
    rev = "186b00a460c9dd8179f9af42fb9a420506ac3aff";
    hash = "sha256-e89/x66S+MpJFtqat1hYEyRVUYFjef62LDN2hQPjNVw=";
  };

  cargoHash = "sha256-C1eD974cEGbo0vHJqdnCPUopDPDDa6hAFJdzSm8t618=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    tests.helpTest = testers.runCommand {
      name = "stardust-xr-kiara";
      script = ''
        kiara --help
        touch $out
      '';
      nativeBuildInputs = [ stardust-xr-kiara ];
    };
  };

  postInstall = ''
    wrapProgram $out/bin/kiara --prefix PATH : ${niri}/bin
  '';

  env = {
    NIRI_CONFIG = "${src}/src/niri_config.kdl";
    STARDUST_RES_PREFIXES = "${src}/res";
  };

  meta = {
    description = "360-degree app shell / DE for Stardust XR using Niri";
    homepage = "https://stardustxr.org/";
    license = lib.licenses.mit;
    mainProgram = "kiara";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
