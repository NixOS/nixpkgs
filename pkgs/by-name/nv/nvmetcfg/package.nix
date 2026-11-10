{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nvmetcfg";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "vifino";
    repo = "nvmetcfg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-u8V+mhVegv9X7LDRXfC9IVTBLh+96oLRzmsIuTJu6PI=";
  };

  cargoHash = "sha256-h45DRNUw6LfVvEB848oab++r0gP+gzuvneh1XjVtpgM=";

  passthru.tests = {
    inherit (nixosTests) nvmetcfg;
  };

  meta = {
    description = "NVMe-oF Target Configuration Utility for Linux";
    homepage = "https://github.com/vifino/nvmetcfg";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "nvmetcfg";
    platforms = lib.platforms.linux;
  };
})
