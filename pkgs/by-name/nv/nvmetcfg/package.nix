{ lib
, rustPlatform
, fetchFromGitHub
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "nvmetcfg";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "vifino";
    repo = "nvmetcfg";
    rev = "v${version}";
    hash = "sha256-LoQTcHM6czzQ5ZwXcklFXf/7WlRsoJTF61UhQ56aleQ=";
  };

  cargoHash = "sha256-yZ4UAx95f/cjeObBtzpiYtwDjgOgkKnD64yGe6ouVGw=";

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
