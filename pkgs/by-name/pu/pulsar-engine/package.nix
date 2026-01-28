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
  version = "0.1.88";

  src = fetchFromGitHub {
    owner = "Far-Beyond-Pulsar";
    repo = "Pulsar-Native";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tEid9d65apuulUM19UagRVA6x0GwfCG9AhQfvO/xWYE=";
  };

  cargoHash = "sha256-nsFrR2+LRswhiw8PQ/bgoQPWaPGeuipbXIK15Co7M34=";

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
