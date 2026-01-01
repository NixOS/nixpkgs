{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sftpman";
<<<<<<< HEAD
  version = "2.1.1";
=======
  version = "2.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "spantaleev";
    repo = "sftpman-rs";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-spI+MAjBT+FFD7X+G0ea9Me8wf+8Gn3kids+Dt6OO+w=";
  };

  cargoHash = "sha256-fx3uC9M9q0rXPrakZ5NYLNVQzhKZgqdjjZLQ90TNvqQ=";

  meta = {
    homepage = "https://github.com/spantaleev/sftpman-rs";
    description = "Application that handles sshfs/sftp file systems mounting";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
    hash = "sha256-6IhMBnp951mKfG054svFTezf3fpOEMJusRj45qVThmA=";
  };

  cargoHash = "sha256-TltizTFKrMvHNQcSoow9fuNLy6appYq9Y4LicEQrfRE=";

  meta = with lib; {
    homepage = "https://github.com/spantaleev/sftpman-rs";
    description = "Application that handles sshfs/sftp file systems mounting";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      contrun
      fugi
    ];
    mainProgram = "sftpman";
  };
})
