{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, protobuf
, nixosTests
, nix-update-script
, withQuic ? false
, # with QUIC protocol support
}:

rustPlatform.buildRustPackage rec {
  pname = "easytier";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "EasyTier";
    repo = "EasyTier";
    tag = "v${version}";
    hash = "sha256-89uRsLeSNR2I+QX0k1VJ0sMrUYLbApEJClk3aFr0faY=";
  };

  # remove if rust 1.89 merged
  postPatch = ''
    substituteInPlace easytier/Cargo.toml \
      --replace-fail 'rust-version = "1.89.0"' ""
    substituteInPlace easytier-rpc-build/Cargo.toml \
      --replace-fail 'rust-version = "1.89.0"' ""
  '';

  cargoHash = "sha256-rioo3Eg5xGg4PI4beXWheeymVNq+zZP9uhbfU584u0g=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ];

  buildNoDefaultFeatures = stdenv.hostPlatform.isMips;
  buildFeatures = lib.optional stdenv.hostPlatform.isMips "mips" ++ lib.optional withQuic "quic";

  doCheck = false; # tests failed due to heavy rely on network

  passthru = {
    tests = { inherit (nixosTests) easytier; };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/EasyTier/EasyTier";
    changelog = "https://github.com/EasyTier/EasyTier/releases/tag/v${version}";
    description = "Simple, decentralized mesh VPN with WireGuard support";
    longDescription = ''
      EasyTier is a simple, safe and decentralized VPN networking solution implemented
      with the Rust language and Tokio framework.
    '';
    mainProgram = "easytier-core";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ ltrump ];
  };
}
