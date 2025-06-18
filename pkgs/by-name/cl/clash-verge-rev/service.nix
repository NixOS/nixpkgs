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
    # FIXME: remove until upstream fix these
    # https://github.com/clash-verge-rev/clash-verge-rev/issues/3428

    # Patch: Restrict bin_path in spawn_process to be under the clash-verge-service directory.
    # This prevents arbitrary code execution by ensuring only trusted binaries from the Nix store are allowed to run.
    ./0001-core-validate-bin_path-to-prevent-RCE-in-start_clash.patch

    # Patch: Add validation to prevent overwriting existing files.
    # This mitigates arbitrary file overwrite risks by ensuring a file does not already exist before writing.
    ./0002-core-prevent-overwriting-existing-file-by-validating.patch
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
