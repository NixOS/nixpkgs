{
  lib,
  rustPlatform,
  cmake,
  perl,
  pkg-config,
  openssl,
  src,
  version,
  cargoHash,
}:

rustPlatform.buildRustPackage {
  pname = "buzz-desktop-sidecars";
  inherit version src cargoHash;

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ];

  buildInputs = [ openssl ];

  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--bin=buzz"
    "--bin=buzz-acp"
    "--bin=buzz-agent"
    "--bin=buzz-backend-kubernetes"
    "--bin=buzz-dev-mcp"
    "--bin=git-credential-nostr"
  ];

  doCheck = false;

  preBuild = ''
    export RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build ''${RUSTFLAGS:-}"
  '';

  meta = {
    description = "Bundled sidecar binaries for Buzz Desktop";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
  };
}
