{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sftpman";
  version = "2.1.1";

  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "spantaleev";
    repo = "sftpman-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-spI+MAjBT+FFD7X+G0ea9Me8wf+8Gn3kids+Dt6OO+w=";
  };

  cargoHash = "sha256-fx3uC9M9q0rXPrakZ5NYLNVQzhKZgqdjjZLQ90TNvqQ=";

  meta = {
    homepage = "https://github.com/spantaleev/sftpman-rs";
    description = "Application that handles sshfs/sftp file systems mounting";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      contrun
      fugi
    ];
    mainProgram = "sftpman";
  };
})
