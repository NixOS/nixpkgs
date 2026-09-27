{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  perl,
  pkg-config,
  dbus,
  udev,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fnox";
  version = "1.35.3";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "fnox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4+7vV4OaqFbtzO093YHooMF6n1soZObiFpC2JLebaXE=";
  };

  cargoHash = "sha256-Fmpf4eArSW8FDHVekmbG+dJuO2UzrsJO9iBUxB2RGAw=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    udev
  ];

  nativeCheckInputs = [ cacert ];
  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

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
