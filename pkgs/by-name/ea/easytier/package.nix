{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  nixosTests,
  nix-update-script,
  installShellFiles,
  withQuic ? false, # with QUIC protocol support
}:

rustPlatform.buildRustPackage rec {
  pname = "easytier";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "EasyTier";
    repo = "EasyTier";
    tag = "v${version}";
    hash = "sha256-vGQHrpImPMF44LXVnKRpj47Nr534wTlVZJiBDm4GkGs=";
  };

  cargoHash = "sha256-B9GkvSXyZXTBsnV7wbipjdZ0EkVrL/aw8Ff7uUvfKPo=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildNoDefaultFeatures = stdenv.hostPlatform.isMips;
  buildFeatures = lib.optional stdenv.hostPlatform.isMips "mips" ++ lib.optional withQuic "quic";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd easytier-cli \
      --bash <($out/bin/easytier-cli gen-autocomplete bash) \
      --fish <($out/bin/easytier-cli gen-autocomplete fish) \
      --zsh <($out/bin/easytier-cli gen-autocomplete zsh)
    installShellCompletion --cmd easytier-core \
      --bash <($out/bin/easytier-core --gen-autocomplete bash) \
      --fish <($out/bin/easytier-core --gen-autocomplete fish) \
      --zsh <($out/bin/easytier-core --gen-autocomplete zsh)
  '';

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
