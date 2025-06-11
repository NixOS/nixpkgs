{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
  nix-update-script,
  rust-jemalloc-sys-unprefixed,
}:

rustPlatform.buildRustPackage rec {
  pname = "qdrant";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    tag = "v${version}";
    hash = "sha256-o9Nv4UsFgVngKWpe5sUR8tovtpB81tJBSm6We6DN20c=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-xt7uu+YZGazbKwXEKXeIwcGg8G4djQx7nKpQYFv/L3Y=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    openssl
    rust-jemalloc-sys
    rust-jemalloc-sys-unprefixed
  ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector Search Engine for the next generation of AI applications";
    longDescription = ''
      Expects a config file at config/config.yaml with content similar to
      https://github.com/qdrant/qdrant/blob/master/config/config.yaml
    '';
    homepage = "https://github.com/qdrant/qdrant";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
