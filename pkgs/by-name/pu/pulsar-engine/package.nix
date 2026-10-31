{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pulsar-engine";
  version = "0.2.42";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Far-Beyond-Pulsar";
    repo = "Pulsar-Native";
    rev = "v${finalAttrs.version}";
    hash = "sha256-choWvca4SPPL+c2rhKCgnJRSqWDrI/mUZDES+NrBmQE=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-3uS5LpKb8ibg9/JMx8NFOgjj7mvsUastTkHrpXJwDGs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    protobuf
  ];

  meta = {
    description = "Next-generation game engine built with GPUI";
    homepage = "https://github.com/Far-Beyond-Pulsar/Pulsar-Native";
    changelog = "https://github.com/Far-Beyond-Pulsar/Pulsar-Native/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
})
