{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rs-tftpd";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    tag = finalAttrs.version;
    hash = "sha256-Q4WeRX0rGlsyp5riy16X5WXMWmWRZABEhCPz+HAiPuo=";
  };

  cargoHash = "sha256-VloKNrje6nmiHZmyO5IGRGIHRc/VfldgYsG5kpmrvyw=";

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
