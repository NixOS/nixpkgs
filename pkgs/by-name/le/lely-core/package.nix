{
  autoreconfHook,
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lely-core";
  version = "2.3.5";

  nativeBuildInputs = [
    autoreconfHook
  ];

  src = fetchFromGitLab {
    owner = "lely_industries";
    repo = "lely-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PuNE/lKsNNd4KDEcSsaz+IfP2hgT5M5VgLY1kVy1KCc=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  meta = {
    description = "High Performance I/O and sensor/actuator control for robotics and IoT applications";
    homepage = "https://opensource.lely.com/canopen/";
    changelog = "https://opensource.lely.com/canopen/release/v${finalAttrs.version}/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aiyion ];
  };
})
