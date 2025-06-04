{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  nix-update-script,
  withQuic ? false, # with QUIC protocol support
}:

rustPlatform.buildRustPackage rec {
  pname = "easytier";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "EasyTier";
    repo = "EasyTier";
    tag = "v${version}";
    hash = "sha256-F///8C7lyJZj5+u80nauDdrPFrEE40s0DeNzQeblImw=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-f64tOU8AKC14tqX9Q3MLa7/pmIuI4FeFGOct8ZTAe+k=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
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
