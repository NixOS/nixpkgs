{
  autoreconfHook,
  fetchFromGitLab,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/lely_industries/lely-core/-/commit/6ed995fa86d828957b636a11470f150830d877ec.patch";
      hash = "sha256-Q4Sza0hs0EE4EZ0nbYAs+/qO2uWKGveZ0+Tgx8xvmEs=";
    })
  ];

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
