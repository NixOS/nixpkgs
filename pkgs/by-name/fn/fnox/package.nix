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
  version = "1.31.1";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "fnox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PAzXu+fltWJXn30RVRUfjCiUUFnt4mb/yeyxM5wCtG8=";
  };

  cargoHash = "sha256-ImD2PEtoTW1ktNpSzGO0ENyXQ/A4f0ydHqZhSIgNroE=";

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
