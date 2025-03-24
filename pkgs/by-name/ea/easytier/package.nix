{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  nix-update-script,
  darwin,
  withQuic ? false, # with QUIC protocol support
}:

rustPlatform.buildRustPackage rec {
  pname = "easytier";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "EasyTier";
    repo = "EasyTier";
    tag = "v${version}";
    hash = "sha256-Heb2ax2yUuGmqzIjrqjHUL3QZoofp7ATrIEN27ZA/Zs=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-U2ZK9GlfTjXsA7Fjd288YDlqSZNl3vHryLG1FE/GH5c=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  buildNoDefaultFeatures = stdenv.hostPlatform.isMips;
  buildFeatures = lib.optional stdenv.hostPlatform.isMips "mips" ++ lib.optional withQuic "quic";

  doCheck = false; # tests failed due to heavy rely on network

  passthru.updateScript = nix-update-script { };

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
