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
  version = "0.2.40";

  src = fetchFromGitHub {
    owner = "Far-Beyond-Pulsar";
    repo = "Pulsar-Native";
    rev = "v${finalAttrs.version}";
    hash = "sha256-leXUT4nTj2QV+xgHo6f6E0Uyk5w7fVuGv0cUlTtqLKE=";
  };

  cargoHash = "sha256-qxVx7DTTqJU/4as47aOrm2j47gBmlU1i8aCXYu9PaKg=";

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
