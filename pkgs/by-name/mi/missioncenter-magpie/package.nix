{
  lib,
  stdenv,
  fetchFromGitHub,
  mission-center,
  fetchFromGitLab,
  rustPlatform,

  # nativeBuildInputs
  cargo,
  cmake,
  meson,
  ninja,
  pkg-config,
  protobuf,
  python3,
  rustc,

  # buildInputs
  libdrm,
  libgbm,
  sqlite,
  udev,
  vulkan-loader,

  versionCheckHook,
}:

let
  nvtop = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = "73291884d926445e499d6b9b71cb7a9bdbc7c393";
    hash = "sha256-8iChT55L2NSnHg8tLIry0rgi/4966MffShE0ib+2ywc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "missioncenter-magpie";
  inherit (mission-center) version;

  src = fetchFromGitLab {
    owner = "mission-center-devs";
    repo = "gng";
    # No tag
    rev = "319d95d29cbc3c373ae61cff228e8440fbaadbbb";
    hash = "sha256-yPAUogIMwOQbd5zmdTubIMRySVf0+KDr0Tvp67PTZnw=";
  };

  postPatch =
    ''
      substituteInPlace meson.build \
        --replace-fail \
          "cargo_opt  = []" \
          "cargo_opt  = ['--offline']" \
        --replace-fail \
          "'CARGO_HOME=' + meson.project_build_root() / 'cargo-home'" \
          "'CARGO_HOME=${finalAttrs.cargoDeps}'"
    ''
    # Prevent platform-linux/build.rs from downloading nvtop
    + ''
      SRC_NVTOP_DIR=$NIX_BUILD_TOP/source/platform-linux/3rdparty/nvtop

      # Patch references in nvtop.json to match the name we inject manually
      substituteInPlace "$SRC_NVTOP_DIR/nvtop.json" \
        --replace-fail "nvtop-${nvtop.rev}" "nvtop-src"

      DEST_NVTOP_DIR=$NIX_BUILD_TOP/source/build/src/debug/build/native/nvtop-src

      mkdir -p "$DEST_NVTOP_DIR"
      cp -r --no-preserve=mode,ownership "${nvtop}"/* "$DEST_NVTOP_DIR"

      pushd "$DEST_NVTOP_DIR"
      mkdir -p include/libdrm
      for patchfile in "$SRC_NVTOP_DIR"/patches/nvtop*.patch; do
        patch -p1 < "$patchfile"
      done
      popd
    ''
    # Patch the shebang of this python script called at build time
    + ''
      patchShebangs platform-linux/hwdb/generate_hwdb.py
    '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    workspace = true;
    hash = "sha256-ouY9zSQ7csAqPzQrbWGtCTB9ECVBKOUX78K5SiqTTxg=";
  };

  nativeBuildInputs = [
    cargo
    cmake
    meson
    ninja
    pkg-config
    protobuf
    python3
    rustPlatform.cargoSetupHook
    rustc
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    libdrm
    libgbm
    sqlite
    udev
    vulkan-loader
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Set of executables and binaries for ";
    homepage = "https://gitlab.com/mission-center-devs/gng";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "missioncenter-magpie";
  };
})
