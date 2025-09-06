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
  version = "0-unstable-2025-06-24";

  # This version is pinned in https://github.com/sideswap-io/sideswapclient/blob/v1.8.0/deploy/build_linux.sh
  src = fetchFromGitHub {
    owner = "sideswap-io";
    repo = "sideswap_rust";
    rev = "91791efbceb3fac4774d1e42a519e70b14b876cf";
    hash = "sha256-SUAmmKnL/thGLfPU22UxzO+LVXgrHh+lZVdXuAJ4q1E=";
  };

  cargoHash = "sha256-bbNFi0cmFFf66IDKi0V8HC/lSU3JLRpgZ+NHeMJog8c=";

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
