{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sftpman";
  version = "2.1.2";

  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "spantaleev";
    repo = "sftpman-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kFh47UmKumEq6bL+bKaYjNHkW3EWPLeFgpqvPglDpEU=";
  };

  cargoHash = "sha256-0BSkHVe/sO/ucShv/oKK1ibO1bZ16nbZR/2kNA0Q9aQ=";

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
