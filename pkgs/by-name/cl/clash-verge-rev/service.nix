{
  version,
  rustPlatform,
  src-service,
  pkg-config,
  openssl,
  pname,
  service-cargo-hash,
  meta,
}:
rustPlatform.buildRustPackage {
  pname = "${pname}-service";
  inherit version meta;

  src = src-service;
  sourceRoot = "${src-service.name}";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  cargoHash = service-cargo-hash;
}
