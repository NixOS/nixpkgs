{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
  protobuf,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pulsar-engine";
  version = "0.1.130";

  src = fetchFromGitHub {
    owner = "Far-Beyond-Pulsar";
    repo = "Pulsar-Native";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vV7lePDto0IIJtlO3yB5f+tJKkHd7P0oCXXjvSCBIrE=";
  };

  cargoHash = "sha256-IJ1U6HhiBTA3YOb8Z1UJlxBgn3+CcYqJmJ9+8wkPCg4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    protobuf
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next-generation game engine built with GPUI";
    homepage = "https://github.com/Far-Beyond-Pulsar/Pulsar-Native";
    changelog = "https://github.com/Far-Beyond-Pulsar/Pulsar-Native/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
})
