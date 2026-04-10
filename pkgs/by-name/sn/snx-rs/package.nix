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
  version = "5.2.4";

  src = fetchFromGitHub {
    owner = "ancwrd1";
    repo = "snx-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jqj2cux11V0l0YRZY2O19PzduvcxB1Ze186jG5Vo+Gs=";
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

  cargoHash = "sha256-XY4kZ1HBwHpb8hHtt0bay80Jc3d3zyAoKQv3m0n1AL4=";

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
