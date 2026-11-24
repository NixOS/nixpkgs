{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  pkg-config,
  aws-lc,
  zstd,
  sqlite,
  nixosTests,
  nix-update-script,
  installShellFiles,
  mold,
  withQuic ? false, # with QUIC protocol support

  formats,
  bash,
  iproute2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "easytier";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "EasyTier";
    repo = "EasyTier";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dJzOUiun3Gg+lnMMmkEZkYRfwr5N0K2Y6r9aazVngWI=";
  };

  cargoHash = "sha256-1GRH5lZjYtdLKJh1Re2ym7F1JJDI9rILYD/djX6p9DY=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    installShellFiles
    mold
    pkg-config
  ];

  buildInputs = [
    aws-lc
    zstd
    sqlite
  ];

  buildNoDefaultFeatures = stdenv.hostPlatform.isMips;
  buildFeatures = [
    "system-certificates"
  ]
  ++ lib.optional stdenv.hostPlatform.isMips "mips"
  ++ lib.optional withQuic "quic";

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
    tests = { inherit (nixosTests) easytier easytier-modular; };
    updateScript = nix-update-script { };
  };

  passthru.services.default = {
    imports = [
      (lib.modules.importApply ./service.nix { inherit formats bash iproute2; })
    ];
    easytier.package = finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://github.com/EasyTier/EasyTier";
    changelog = "https://github.com/EasyTier/EasyTier/releases/tag/v${finalAttrs.version}";
    description = "Simple, decentralized mesh VPN with WireGuard support";
    longDescription = ''
      EasyTier is a simple, safe and decentralized VPN networking solution implemented
      with the Rust language and Tokio framework.
    '';
    mainProgram = "easytier-core";
    license = lib.licenses.lgpl3Only;
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ ltrump ];
  };
})
