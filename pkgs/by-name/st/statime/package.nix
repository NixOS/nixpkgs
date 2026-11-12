{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "statime";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pendulum-project";
    repo = "statime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hevR2pGBG70bnGldSyWK6MGs6lA9R1Bj8sko2WwMTvs=";
  };

  cargoHash = "sha256-6/XUyOYmj5g6sO8RXEofHqsM08bUObFO3GoKgG1pyI0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the Precision Time Protocol (PTP) in Rust";
    homepage = "https://github.com/pendulum-project/statime";
    changelog = "https://github.com/pendulum-project/statime/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ s0me1newithhand7s ];
    mainProgram = "statime";
    platforms = lib.platforms.linux;
  };
})
