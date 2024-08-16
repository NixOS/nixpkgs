{ lib
, stdenv
, fetchFromGitHub
, cargo
, cmake
, pkg-config
, rustPlatform
, rustc
, wrapQtAppsHook
, fcitx5
, ibus
, qtbase
, zstd
, fetchpatch
, withFcitx5Support ? false
, withIbusSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "openbangla-keyboard";
  version = "unstable-2023-07-21";

  src = fetchFromGitHub {
    owner = "openbangla";
    repo = "openbangla-keyboard";
    # no upstream release in 3 years
    # fcitx5 support was added over a year after the last release
    rev = "780bd40eed16116222faff044bfeb61a07af158f";
    hash = "sha256-4CR4lgHB51UvS/RLc0AEfIKJ7dyTCOfDrQdGLf9de8E=";
    fetchSubmodules = true;
  };

  patches = [
    # prevents runtime crash when fcitx5-based IM attempts to look in /usr
    (fetchpatch {
      name = "use-CMAKE_INSTALL_PREFIX-for-loading-data.patch";
      url = "https://github.com/OpenBangla/OpenBangla-Keyboard/commit/f402472780c29eaa6b4cc841a70289adf171462b.diff";
      hash = "sha256-YahvtyOxe8F40Wfe+31C6fdmm197QN26/Q67oinOplk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    wrapQtAppsHook
  ];

  buildInputs = lib.optionals withFcitx5Support [
    fcitx5
  ] ++ lib.optionals withIbusSupport [
    ibus
  ] ++ [
    qtbase
    zstd
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock
    '';
    sourceRoot = "${src.name}/${cargoRoot}";
    hash = "sha256-XMleyP2h1aBhtjXhuGHyU0BN+tuL12CGoj+kLY5uye0=";
  };

  cmakeFlags = lib.optionals withFcitx5Support [
    "-DENABLE_FCITX=YES"
  ] ++ lib.optionals withIbusSupport [
    "-DENABLE_IBUS=YES"
  ];

  cargoRoot = "src/engine/riti";
  postPatch = ''
    cp ${./Cargo.lock} ${cargoRoot}/Cargo.lock
 '';

  meta = {
    isIbusEngine = withIbusSupport;
    description = "OpenSource, Unicode compliant Bengali Input Method";
    mainProgram = "openbangla-gui";
    homepage = "https://openbangla.github.io/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eclairevoyant hqurve ];
    platforms = lib.platforms.linux;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
