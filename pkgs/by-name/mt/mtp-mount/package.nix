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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "vdavid";
    repo = "mtp-mount";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SRB1fc7dqgY7jdpVYAnoEiH+MToQb0E1F93eHbduW1o=";
  };

  cargoHash = "sha256-DHevvcyP2yNIDFPnVsyothGfdum2e3F73KGHjyqgf38=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fuse3 ];

  checkFlags = [
    # test_unregistering_a_virtual_device_does_not_disconnect_an_open_one fails in the sandbox
    "--skip=test_unregistering_a_virtual_device_does_not_disconnect_an_open_one"
  ];

  passthru = {
    tests.version = testers.testVersion { package = mtp-mount; };
    updateScript = nix-update-script { };
  };

  __structuredAttrs = true;

  meta = {
    description = "Mount MTP devices as local filesystems via FUSE";
    homepage = "https://github.com/vdavid/mtp-mount";
    changelog = "https://github.com/vdavid/mtp-mount/blob/${finalAttrs.src.tag}/CHANGELOG.md";
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
