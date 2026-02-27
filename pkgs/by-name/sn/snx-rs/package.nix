{
  fetchFromGitHub,
  glib,
  gtk4,
  kdePackages,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  wrapGAppsHook4,
  graphene,
  sqlite,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snx-rs";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "ancwrd1";
    repo = "snx-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-whmZM6OYdHtcTJzzR4aqDMBVpFuRvJKLFVGCQNDjRw8=";
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    kdePackages.kstatusnotifieritem
    openssl
    graphene
    sqlite
  ];

  checkFlags = [
    "--skip=platform::linux::net::tests::test_default_ip"
    "--skip=platform::linux::tests::test_xfrm_check"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  cargoHash = "sha256-gAOxwmsPo0XpFxNe3EObNlgiTJ0krMAlVaTDorrYUqg=";

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/snx-rs";

  meta = {
    description = "Open source Linux client for Checkpoint VPN tunnels";
    homepage = "https://github.com/ancwrd1/snx-rs";
    license = lib.licenses.agpl3Plus;
    changelog = "https://github.com/ancwrd1/snx-rs/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      shavyn
    ];
    mainProgram = "snx-rs";
  };
})
