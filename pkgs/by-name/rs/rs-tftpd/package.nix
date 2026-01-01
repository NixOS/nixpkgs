{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rs-tftpd";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    tag = finalAttrs.version;
    hash = "sha256-ObGJVoFI4HTQ2tuoFbMBrub/64X9AMF/oCs1OPXzWJ8=";
  };

  cargoHash = "sha256-oQOT4P4/zGXLe7gMetBqTIRDWbroKp8sCChQFgeZ0zs=";

  buildFeatures = [ "client" ];

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    changelog = "https://github.com/altugbakan/rs-tftpd/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    changelog = "https://github.com/altugbakan/rs-tftpd/releases/tag/${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      adamcstephens
      matthewcroughan
    ];
    mainProgram = "tftpd";
  };
})
