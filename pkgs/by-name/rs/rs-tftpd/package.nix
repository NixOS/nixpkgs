{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rs-tftpd";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    tag = finalAttrs.version;
    hash = "sha256-ozp/PAc5rFexr81Sx0MPaBLIyggttjImdt+Vs7BDnfc=";
  };

  cargoHash = "sha256-mu7o0vqI12bR0z9YaBa36JNgVbLVGZfpQpnsCqhckeU=";

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
