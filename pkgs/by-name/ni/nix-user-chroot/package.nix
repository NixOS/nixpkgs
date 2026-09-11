{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkgsStatic,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-user-chroot";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-user-chroot";
    tag = finalAttrs.version;
    hash = "sha256-PU71ulCYaT7vM70ariJAgOXBqfBzWDsMh+l4tcnbGYw=";
  };

  cargoHash = "sha256-VgwLuR+ZGIZi2aTBAevngTyZLswduFbKzoFgL9TFUj4=";

  passthru.updateScript = nix-update-script { };

  env.NIX_USER_CHROOT_TEST_BUSYBOX = "${pkgsStatic.busybox}/bin/busybox";
  checkFlags = [
    "--skip=run_nix_install" # Test requires network
  ];

  meta = {
    description = "Install & Run Nix Programs without root permissions";
    homepage = "https://github.com/nix-community/nix-user-chroot";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      eveeifyeve
      mic92
    ];
    mainProgram = "nix-user-chroot";
  };
})
