{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  perl,
  webkitgtk_4_1,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gpauth";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dxRqf5iOlgJegeAqtTwoVqNHXU3eOse5eMYFknhAh2M=";
    fetchSubmodules = true;
  };

  buildAndTestSubdir = "apps/gpauth";

  cargoHash = "sha256-VkDq98Y6uBSal7m4V9vjW1XermOPOWulo3Jo34QFRsA=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/blob/${finalAttrs.src.rev}/changelog.md";
    description = "CLI for GlobalProtect VPN, based on OpenConnect, supports the SSO authentication method";
    longDescription = ''
      A CLI for GlobalProtect VPN, based on OpenConnect, supports the SSO
      authentication method. Inspired by gp-saml-gui.

      The CLI version is always free and open source in this repo. It has almost
      the same features as the GUI version.
    '';
    homepage = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      binary-eater
      booxter
      m1dugh
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
