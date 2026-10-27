{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  rustPlatform,
  protobuf,
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
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "EasyTier";
    repo = "EasyTier";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t/a4V1pMoqr9fVfMGHJUfJPk8VD+mbOxB2Cvb2lsX9Q=";
  };

  cargoHash = "sha256-/dVCPkDGgvDEUnCb1EfH2Y0Yn48h4mYuUben0GNwvoo=";

  patches = [
    # TODO: remove after next release
    # `dep:` in easytier-core drops the implicit `smoltcp` feature that
    # cargo-auditable expects; see rust-secure-code/cargo-auditable#124.
    (fetchpatch2 {
      name = "expose-smoltcp-feature.patch";
      url = "https://github.com/EasyTier/EasyTier/commit/3a0acccf46eff19c88d372a4b06749eccc9fa708.patch?full_index=1";
      hash = "sha256-tV7TtBF8WPmVnVYp7KiaS8Ek48Y/6BmRSICF38Q2ESc=";
    })
    # Building easytier-web next to the CLI enables two rustls backends, which
    # makes HTTPS peer discovery panic; backport of EasyTier/EasyTier#2648.
    ./0002-rustls-select-ring-provider-explicitly.patch
  ];

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    installShellFiles
    mold
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
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ ltrump ];
  };
})
