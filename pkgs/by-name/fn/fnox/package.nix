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
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "fnox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BwuMuiJiC5QbtlfZz/aqSXQmjyf0jUWv2sNdKEK3LJY=";
  };

  cargoHash = "sha256-vU1LA6vvNpLFRXj07WmtCoWDdJezqMoI/t7q7E77JUk=";

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
