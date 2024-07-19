{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  bluez,
  cmake,
  dbus,
  libftdi1,
  nix-update-script,
  pkg-config,
  useLibFTDI ? true,
  useOpenMP ? true,
  buildBluetooth ? true,
  buildBluetoothLowEnergy ? true,
  buildONNX ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brainflow";
  version = "5.12.1";

  src = fetchFromGitHub {
    owner = "brainflow-dev";
    repo = "brainflow";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-haQO03nkvLoXtFVe+C+yi+MwM0CFh6rLcLvU8fQ4k/w=";
  };

  patches = [
    # All of these are PRs that were merged into the upstream repository and will be included in the next release
    # These should be removed once the next version is released
    (fetchpatch {
      # Fixes a major issue that prevented the build from working at all (why was this not backported???)
      url = "https://github.com/brainflow-dev/brainflow/commit/883b0cd08acb99d7b6e241e92fba2e9a363d17b1.patch";
      hash = "sha256-QQd+BI3I65gfaNS/SKLjCoqbCwPCiTh+nh0tJAZM6hQ=";
    })
    (fetchpatch {
      # Bumps the version of a python dependency that had a backwards-incompatible change
      url = "https://github.com/brainflow-dev/brainflow/commit/ea23a6f0483ce4d6fdd7a82bace865356ee78d7f.patch";
      hash = "sha256-dvMpxxRrnJQ9ADGagB1JhuoB9SNwn755wbHzW/3ECeo=";
    })
    (fetchpatch {
      # Fixes an incorrect use of an environment variable during the build
      url = "https://github.com/brainflow-dev/brainflow/commit/053b8c1253b686cbec49ab4adb47c9ee02d3f99a.patch";
      hash = "sha256-Pfhe1ZvMagfVAGZqeWn1uHXgwlTtkOm+gyWuvC5/Sro=";
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_LIBFTDI" useLibFTDI)
    (lib.cmakeBool "USE_OPENMP" useOpenMP)
    (lib.cmakeBool "BUILD_OYMOTION_SDK" false) # Needs a "GFORCE_SDK"
    (lib.cmakeBool "BUILD_BLUETOOTH" buildBluetooth)
    (lib.cmakeBool "BUILD_BLE" buildBluetoothLowEnergy)
    (lib.cmakeBool "BUILD_ONNX" buildONNX)
  ];

  buildInputs =
    [ dbus ]
    ++ lib.optional (buildBluetooth || buildBluetoothLowEnergy) bluez
    ++ lib.optional useLibFTDI libftdi1;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  postPatch = ''
    find . -type f -name 'build.cmake' -exec \
    sed -i 's/DESTINATION inc/DESTINATION include/g' {} \;
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A library to obtain, parse and analyze data (EEG, EMG, ECG) from biosensors";
    homepage = "https://brainflow.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pandapip1
      ziguana
    ];
    platforms = lib.platforms.all;
  };
})
