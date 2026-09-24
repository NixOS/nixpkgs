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
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WCCSd20qkDtJ88ru+ufFZrNQZSKkCzYo5fZpbB7Sn7o=";
    fetchSubmodules = true;
  };

  buildAndTestSubdir = "apps/gpauth";

  cargoHash = "sha256-6+x5SRQHIchtkdYZAZl+b28hMCaiQHrp9i3tMsN3DhE=";

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

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fail in sandbox because netdev tries to read SystemConfiguration
    "--skip=cli::tests::host_id_arg_sets_profile_host_id_seed"
    "--skip=cli::tests::client_version_arg_sets_profile_client_version"
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
      booxter
      m1dugh
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
