{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sftpman";
  version = "2.1.0";

  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "spantaleev";
    repo = "sftpman-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6IhMBnp951mKfG054svFTezf3fpOEMJusRj45qVThmA=";
  };

  cargoHash = "sha256-TltizTFKrMvHNQcSoow9fuNLy6appYq9Y4LicEQrfRE=";

  meta = with lib; {
    homepage = "https://github.com/spantaleev/sftpman-rs";
    description = "Application that handles sshfs/sftp file systems mounting";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      contrun
      fugi
    ];
    mainProgram = "sftpman";
  };
})
