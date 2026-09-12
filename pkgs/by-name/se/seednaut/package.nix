{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "seednaut";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Baltram";
    repo = "seednaut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wyMOZQPJPSqLl4tzC5NELoe81aJZSOurifi62v1+jcQ=";
  };

  cargoHash = "sha256-1GZ7ZoiGKEQGN2AQFcz/YXpcqg3iYLRSzl2GfTmGk8g=";

  meta = {
    description = "Inspect, verify and extract files from Seedvault Android backups";
    longDescription = ''
      A command-line and terminal UI utility for Seedvault, the backup
      mechanism integrated by Android distributions such as CalyxOS,
      GrapheneOS, iodéOS, LineageOS and /e/OS. It works fully offline and
      supports the current backup formats (v2 app backup, v0 file backup),
      allowing backups to be verified, explored and extracted off-device.
    '';
    homepage = "https://github.com/Baltram/seednaut";
    changelog = "https://github.com/Baltram/seednaut/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "seednaut";
    maintainers = with lib.maintainers; [ _6543 ];
  };
})
