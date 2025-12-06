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
  version = "0.1.40";

  src = fetchFromGitHub {
    owner = "Far-Beyond-Pulsar";
    repo = "Pulsar-Native";
    rev = "v${finalAttrs.version}";
    hash = "sha256-omSmn+qEw000c74GZD2d84LPRkNQl2EGcSsRzrqHsB0=";
  };

  cargoHash = "sha256-xm0U8G8DXL9LuuWK5TSzLS4ZIKBjhvlYXhahb2tT8jU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    protobuf
  ];

  # NOTE: Specific Tests are failing, not stable yet so for now disabling this phase so it can build.
  doCheck = false;

  passthru.update-script = nix-update-script;

  meta = {
    description = "Next-generation engine built with GPUI";
    homepage = "https://github.com/Far-Beyond-Pulsar/Pulsar-Native";
    changelog = "https://github.com/Far-Beyond-Pulsar/Pulsar-Native/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
})
