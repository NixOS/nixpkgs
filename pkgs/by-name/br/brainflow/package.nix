{ lib
, stdenv
, fetchFromGitHub
, bluez
, cmake
, dbus
, libftdi1
, nix-update-script
, pkg-config
, useLibFTDI ? true
, useOpenMP ? true
, buildBluetooth ? true
, buildBluetoothLowEnergy ? true
, buildONNX ? true
}:

stdenv.mkDerivation rec {
  pname = "brainflow";
  version = "unstable-2024-05-01"; # Latest release has broken build

  src = fetchFromGitHub {
    owner = "brainflow-dev";
    repo = "brainflow";
    #rev = "refs/tags/${version}";
    rev = "41c304e7545a7465b06201dd4652ef93822edb83";
    hash = "sha256-wazbL4LGn9aLS5Ek8EW/rt4S+VHyusqTjvZWNBTKS3w=";
  };

  cmakeFlags = with lib; [
    (cmakeBool "USE_LIBFTDI" useLibFTDI)
    (cmakeBool "USE_OPENMP" useOpenMP)
    (cmakeBool "BUILD_OYMOTION_SDK" false) # Needs a "GFORCE_SDK"
    (cmakeBool "BUILD_BLUETOOTH" buildBluetooth)
    (cmakeBool "BUILD_BLE" buildBluetoothLowEnergy)
    (cmakeBool "BUILD_ONNX" buildONNX)
  ];

  buildInputs = [
    dbus
  ] ++ lib.optional (buildBluetooth || buildBluetoothLowEnergy) bluez
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

  meta = with lib; {
    description = "BrainFlow is a library intended to obtain, parse and analyze EEG, EMG, ECG and other kinds of data from biosensors.";
    homepage = "https://brainflow.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ pandapip1 ziguana ];
  };
}
