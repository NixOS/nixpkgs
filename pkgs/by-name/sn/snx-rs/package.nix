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
  version = "4.4.4";

  src = fetchFromGitHub {
    owner = "ancwrd1";
    repo = "snx-rs";
    tag = "v${version}";
    hash = "sha256-FVrj26pQthy6gY6UWXD4ACvy0/PPLXM0zrGOIjXl07U=";
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZzVTl1IVTAut+7o9QXaPDk8QCemRt2EoYX/Wi0RXJ3U=";

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
