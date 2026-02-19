{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  cmake,
  pkg-config,
  rustPlatform,
  rustc,
  wrapQtAppsHook,
  fcitx5,
  ibus,
  qtbase,
  zstd,
  withFcitx5Support ? false,
  withIbusSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openbangla-keyboard";
  version = "2.0.0-unstable-2025-08-19";

  src = fetchFromGitHub {
    owner = "openbangla";
    repo = "openbangla-keyboard";
    rev = "723e348ad2cb0607684d907ce8a9457e12993f4f";
    hash = "sha256-XAcL4gBcu84DMR6o9JSJ/PmI1PsDdTETknD6C48E8ek=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    wrapQtAppsHook
  ];

  buildInputs =
    lib.optionals withFcitx5Support [
      fcitx5
    ]
    ++ lib.optionals withIbusSupport [
      ibus
    ]
    ++ [
      qtbase
      zstd
    ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot postPatch;
    hash = "sha256-UrS12fcXIIT3xhl/nyegwROBMCIepi6n07CS5CEA2BY=";
  };

  cmakeFlags =
    lib.optionals withFcitx5Support [
      "-DENABLE_FCITX=YES"
    ]
    ++ lib.optionals withIbusSupport [
      "-DENABLE_IBUS=YES"
    ];

  cargoRoot = "src/engine/riti";
  postPatch = ''
    cp ${./Cargo.lock} ${finalAttrs.cargoRoot}/Cargo.lock
  '';

  meta = {
    isIbusEngine = withIbusSupport;
    description = "OpenSource, Unicode compliant Bengali Input Method";
    mainProgram = "openbangla-gui";
    homepage = "https://openbangla.github.io/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      hqurve
      johnrtitor
    ];
    platforms = lib.platforms.linux;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
})
