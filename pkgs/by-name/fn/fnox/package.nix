{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  perl,
  pkg-config,
  testers,
  dbus,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "fnox";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "fnox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sXFcvpAcHrzRbqYLIrq844TH1dHY1G23QIQoIcsCLGY=";
  };

  cargoHash = "sha256-BhBWghjPC8qs5oKECmddV250YO4/hSWupOz+J9DYKog=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    udev
  ];

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

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
