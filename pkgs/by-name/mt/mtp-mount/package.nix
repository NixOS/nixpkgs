{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fuse3,
  testers,
  mtp-mount,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mtp-mount";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "vdavid";
    repo = "mtp-mount";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RxLFqonT+j1B9yyb7cQuoeFqtDAv26rqf5MI3x/v2iM=";
  };

  cargoHash = "sha256-4aUbMWeCbWoLJaqtANUjts0hXoe1HR85M0I75niHmqQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fuse3 ];

  # test_unregistering_a_virtual_device_does_not_disconnect_an_open_one fails in the sandbox
  doCheck = false;

  passthru = {
    tests.version = testers.testVersion { package = mtp-mount; };
    updateScript = nix-update-script { };
  };

  __structuredAttrs = true;

  meta = {
    description = "Mount MTP devices as local filesystems via FUSE";
    homepage = "https://github.com/vdavid/mtp-mount";
    changelog = "https://github.com/vdavid/mtp-mount/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      agustinmista
    ];
    mainProgram = "mtp-mount";
    platforms = lib.platforms.linux;
  };
})
