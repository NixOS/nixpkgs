{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  systemd,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libsideswap-client";
  version = "0-unstable-2026-02-16";

  # This version is pinned in https://github.com/sideswap-io/sideswapclient/blob/v1.8.0/deploy/build_linux.sh
  src = fetchFromGitHub {
    owner = "sideswap-io";
    repo = "sideswap_rust";
    rev = "9b0eea90b18007621eb15282d0064976dfedfa91";
    hash = "sha256-vnuDIcdHRmTdx/6iRd1g0AQqvvm3ZJs2e8yyx78UDZ4=";
  };

  cargoHash = "sha256-GzAR58UYictCfC6U9mcBZUcejy6jP9brLuKB2yVgccM=";

  # sideswap_client uses vergen to detect Git commit hash at build time. It
  # tries to access .git directory which is not present in Nix build dir.
  # Here we patch that place to use a hardcoded commit hash instead.
  postPatch = ''
    substituteInPlace sideswap_client/src/ffi.rs \
      --replace-fail 'env!("VERGEN_GIT_SHA");' '"${finalAttrs.src.rev}";'

    substituteInPlace sideswap_client/build.rs \
      --replace-fail 'vergen::vergen(vergen::Config::default()).unwrap();' ' '
  '';

  # This is needed for pkg-config to find libudev. It is a part of systemd.
  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [ systemd ];

  cargoBuildFlags = [
    "--package"
    "sideswap_client"
  ];

  # Test gdk_registry_cache::tests::basic hangs in Nix build invironment.
  doCheck = false;

  meta = {
    description = "Rust library for Sideswap";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ starius ];
  };
})
