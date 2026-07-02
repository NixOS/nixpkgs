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
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RDfxhf0t70Ex6MfgHAX2AaWcPAwTCvjm1bQkek+92zc=";
    fetchSubmodules = true;
  };

  buildAndTestSubdir = "apps/gpauth";

  cargoHash = "sha256-SY0PS5GxvVO1jaCNyLa3/l/v8/JT2R+4lM3W9kA7fVM=";

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
