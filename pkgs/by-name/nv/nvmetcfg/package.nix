{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "nvmetcfg";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "vifino";
    repo = "nvmetcfg";
    rev = "v${version}";
    hash = "sha256-u8V+mhVegv9X7LDRXfC9IVTBLh+96oLRzmsIuTJu6PI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-h45DRNUw6LfVvEB848oab++r0gP+gzuvneh1XjVtpgM=";

  passthru.tests = {
    inherit (nixosTests) nvmetcfg;
  };

  meta = with lib; {
    description = "NVMe-oF Target Configuration Utility for Linux";
    homepage = "https://github.com/vifino/nvmetcfg";
    license = licenses.isc;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "nvmetcfg";
    platforms = platforms.linux;
  };
}
