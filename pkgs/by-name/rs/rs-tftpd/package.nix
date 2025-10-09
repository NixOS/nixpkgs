{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rs-tftpd";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    tag = finalAttrs.version;
    hash = "sha256-YxXUwbzkuxnRrri49DhjvO/LJRWWtFutLbg151GnT5M=";
  };

  cargoHash = "sha256-FKwQr4u7lVN12XPyDus7QoIpthYbT84SFkMJvLTqXRU=";

  buildFeatures = [ "client" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    changelog = "https://github.com/altugbakan/rs-tftpd/releases/tag/${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      adamcstephens
      matthewcroughan
    ];
    mainProgram = "tftpd";
  };
})
