{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rs-tftpd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    tag = finalAttrs.version;
    hash = "sha256-zdchV2WKkOyHPN4N0pFFavPXv8fcGgjoRKLAUbj5Rto=";
  };

  cargoHash = "sha256-I49jiMcC9ndk8GuCKJE3+qS7F6V38meUdbtrxKJNhsg=";

  buildFeatures = [ "client" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    changelog = "https://github.com/altugbakan/rs-tftpd/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adamcstephens
      matthewcroughan
    ];
    mainProgram = "tftpd";
  };
})
