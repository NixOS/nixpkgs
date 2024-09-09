{
  version,
  rustPlatform,
  src-service,
  pkg-config,
  openssl,
  pname,
  webkitgtk,
  service-cargo-hash,
}:
rustPlatform.buildRustPackage {
  pname = "${pname}-service";
  inherit version;

  src = src-service;
  sourceRoot = "${src-service.name}";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    openssl
    webkitgtk
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  cargoHash = service-cargo-hash;
}
