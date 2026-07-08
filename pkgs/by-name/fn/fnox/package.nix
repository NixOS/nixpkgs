{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
  pkg-config,
  testers,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "fnox";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "fnox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8LNMJEZNUlwpPT674/6SfR5dmFRALDI6X1WLKeaJ06M=";
  };

  cargoHash = "sha256-SoQseyrRqvq/XRmd/HhMX8r42pyn4Ncw6r9G4596bGc=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [ udev ];

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  checkFlags = [
    # requires a D-Bus session unavailable in the sandbox
    "--skip=providers::keychain::tests::test_keychain_set_and_get"
  ];

  meta = {
    description = "Flexible secret management tool supporting multiple providers and encryption methods";
    homepage = "https://github.com/jdx/fnox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tiptenbrink ];
    platforms = lib.platforms.linux;
  };
})
