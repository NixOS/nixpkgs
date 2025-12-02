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
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "snx-rs";
  version = "4.9.1";

  src = fetchFromGitHub {
    owner = "ancwrd1";
    repo = "snx-rs";
    tag = "v${version}";
    hash = "sha256-7qmwi/hV8Ev+rdG00hIrQ8yMkb/yxAvG49SAvjsO4GQ=";
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
  ];

  checkFlags = [
    "--skip=platform::linux::net::tests::test_default_ip"
    "--skip=platform::linux::tests::test_xfrm_check"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  cargoHash = "sha256-RRmssKIzxhcmZjTqF0fRmw8XyyHFRwLJtGOF/xeD78w=";

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/snx-rs";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Open source Linux client for Checkpoint VPN tunnels";
    homepage = "https://github.com/ancwrd1/snx-rs";
    license = lib.licenses.agpl3Plus;
    changelog = "https://github.com/ancwrd1/snx-rs/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      shavyn
    ];
    mainProgram = "snx-rs";
  };
}
