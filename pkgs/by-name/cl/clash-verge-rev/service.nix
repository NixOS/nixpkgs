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

  patches = [
    # Only fix for nix by moraxyc
    # FIXME: remove until upstream fix it
    # https://github.com/clash-verge-rev/clash-verge-rev/issues/3428
    # Patch: Restrict bin_path in spawn_process to be under the clash-verge-service directory.
    # This prevents arbitrary code execution by ensuring only trusted binaries from the Nix store are allowed to run.
    ./0001-valid-bin-path.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  useFetchCargoVendor = true;
  cargoHash = service-cargo-hash;
}
