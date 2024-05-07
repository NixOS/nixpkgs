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
    # These PRs have both been merged. These bug fixes will not be needed in the next release.
    (fetchpatch {
      url = "https://github.com/brainflow-dev/brainflow/commit/883b0cd08acb99d7b6e241e92fba2e9a363d17b1.patch";
      hash = "sha256-QQd+BI3I65gfaNS/SKLjCoqbCwPCiTh+nh0tJAZM6hQ=";
    })
  ];

  cmakeFlags = with lib; [
    (cmakeBool "USE_LIBFTDI" useLibFTDI)
    (cmakeBool "USE_OPENMP" useOpenMP)
    (cmakeBool "BUILD_OYMOTION_SDK" false) # Needs a "GFORCE_SDK"
    (cmakeBool "BUILD_BLUETOOTH" buildBluetooth)
    (cmakeBool "BUILD_BLE" buildBluetoothLowEnergy)
    (cmakeBool "BUILD_ONNX" buildONNX)
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
