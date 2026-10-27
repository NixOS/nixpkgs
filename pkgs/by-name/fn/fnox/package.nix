{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  perl,
  pkg-config,
  openssl,
  dbus,
  udev,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fnox";
  version = "1.42.1";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "fnox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hsl0MYwRkZpixeeyWFB7MY9c93Z/FuHQqCWfG06C0go=";
  };

  cargoHash = "sha256-pqkwjWftAP8K7vEopAcPiauUro8XsEwHZS2DcPHgR9c=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    udev
  ];

  nativeCheckInputs = [ cacert ];

  env = {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    OPENSSL_NO_VENDOR = 1;
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  checkFlags = [
    # requires a D-Bus session unavailable in the sandbox
    "--skip=providers::keychain::tests::test_keychain_set_and_get"
  ];

  meta = {
    description = "Flexible secret management tool supporting multiple providers and encryption methods";
    homepage = "https://github.com/jdx/fnox";
    changelog = "https://github.com/jdx/fnox/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tiptenbrink
      Br1ght0ne
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
