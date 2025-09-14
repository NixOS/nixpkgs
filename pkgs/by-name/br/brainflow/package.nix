{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "5.18.1";

  src = fetchFromGitHub {
    owner = "brainflow-dev";
    repo = "brainflow";
    tag = finalAttrs.version;
    hash = "sha256-VcWYH7DXpm0I8IgeDUTFs/13NfEIR5Q74iKFbFWReIA=";
  };

  patches = [ ];

  cmakeFlags = [
    (lib.cmakeBool "USE_LIBFTDI" useLibFTDI)
    (lib.cmakeBool "USE_OPENMP" useOpenMP)
    (lib.cmakeBool "BUILD_OYMOTION_SDK" false) # Needs a "GFORCE_SDK"
    (lib.cmakeBool "BUILD_BLUETOOTH" buildBluetooth)
    (lib.cmakeBool "BUILD_BLE" buildBluetoothLowEnergy)
    (lib.cmakeBool "BUILD_ONNX" buildONNX)
  ];

  buildInputs = [
    dbus
  ]
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
    description = "Library to obtain, parse and analyze data (EEG, EMG, ECG) from biosensors";
    homepage = "https://brainflow.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pandapip1
      ziguana
    ];
    platforms = lib.platforms.all;
  };
})
