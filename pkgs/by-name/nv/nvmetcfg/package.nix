{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nvmetcfg";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "vifino";
    repo = "nvmetcfg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LoQTcHM6czzQ5ZwXcklFXf/7WlRsoJTF61UhQ56aleQ=";
  };

  cargoHash = "sha256-c/6tz68ZI42RgD2N4WZI3nzFo2J5gjk8UoPlelQaxIo=";

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
