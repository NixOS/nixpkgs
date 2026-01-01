{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  rustPlatform,
<<<<<<< HEAD
  systemdMinimal,
  symlinkJoin,

=======
  symlinkJoin,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # nativeBuildInputs
  blueprint-compiler,
  cargo,
  makeWrapper,
  libxml2,
  meson,
  ninja,
  pkg-config,
  protobuf,
  python3,
  rustc,
  wrapGAppsHook4,
<<<<<<< HEAD

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # buildInputs
  appstream-glib,
  cairo,
  cmake,
  dbus,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  glib,
  graphene,
  gtk4,
  libadwaita,
  libdrm,
  libgbm,
  pango,
  sqlite,
  udev,
  wayland,
<<<<<<< HEAD

  # tests
  versionCheckHook,

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # magpie wrapper
  addDriverRunpath,
  libGL,
  vulkan-loader,
<<<<<<< HEAD
=======
  versionCheckHook,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

# UPDATE PROCESS:
# 1) Get the nvtop commit hash (`source-url` in `nvtop.json`):
#   - Go to https://gitlab.com/mission-center-devs/mission-center/-/blob/v<VERSION>/subprojects
#   - Click on magpie
#   - Open platform-linux/3rdparty/nvtop/nvtop.json
#   - The hash is in `source-url`
#
# 2) Update the version of the main derivation
# 3) Refresh all hashes:
#   - main `src`
#   - `nvtop` (if needed)
#   - **both** CargoDeps hashes

let
  nvtop = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
<<<<<<< HEAD
    rev = "339ee0b10a64ec51f43d27357b0068a40f16e9e4";
    hash = "sha256-QxGP6lHbjS7GAQGWUnxFdrYgxBVhtuk5CzS2EUVFjOs=";
=======
    rev = "73291884d926445e499d6b9b71cb7a9bdbc7c393";
    hash = "sha256-8iChT55L2NSnHg8tLIry0rgi/4966MffShE0ib+2ywc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mission-center";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "mission-center-devs";
    repo = "mission-center";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-KETaCjKTxEvh3tgLzJw5PLJHAQivqXhGYcluvFhGGd8=";
=======
    hash = "sha256-TvrYwuJR03mvPc8oXBx6GClOLc+r5kblaOj0uaLwbwE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch =
    # Prevent platform-linux/build.rs from downloading nvtop
    ''
      substituteInPlace src/magpie_client/client.rs \
        --replace-fail \
          '"missioncenter-magpie"' \
          '"${placeholder "out"}/bin/missioncenter-magpie"'

      SRC_DIR=$NIX_BUILD_TOP/source
      SRC_MAGPIE_DIR=$SRC_DIR/subprojects/magpie
      SRC_NVTOP_DIR=$SRC_MAGPIE_DIR/platform-linux/3rdparty/nvtop

      # Patch references in nvtop.json to match the name we inject manually
      substituteInPlace "$SRC_NVTOP_DIR/nvtop.json" \
        --replace-fail "nvtop-${nvtop.rev}" "nvtop-src"

      DEST_NVTOP_DIR=$SRC_DIR/build/subprojects/magpie/src/debug/build/native/nvtop-src

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
      patchShebangs $SRC_MAGPIE_DIR/platform-linux/hwdb/generate_hwdb.py
<<<<<<< HEAD
    ''
    # Inject the absolute path to the udevadm binary in magpie's source code
    + ''
      substituteInPlace subprojects/magpie/platform-linux/src/memory.rs \
        --replace-fail "udevadm" "${lib.getExe' systemdMinimal "udevadm"}"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    '';

  cargoDeps = symlinkJoin {
    name = "cargo-vendor-dir";
    paths = [
      (rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
<<<<<<< HEAD
        hash = "sha256-XS+/gpCMIqDgFR6AjuT2q+p+85GklUuRhKWzaBfQjZg=";
=======
        hash = "sha256-1Bcxp0EuHbJrLQIb2STLNIL2BM2eOgL8ftx4g1o/JY4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
      (rustPlatform.fetchCargoVendor {
        pname = "${finalAttrs.pname}-magpie";
        inherit (finalAttrs) version src;
        sourceRoot = "${finalAttrs.src.name}/subprojects/magpie";
<<<<<<< HEAD
        hash = "sha256-9YZ2dgIaq0AtS8QsIC/0cJlELIy/UbOvulgZFL/qRRs=";
=======
        hash = "sha256-ouY9zSQ7csAqPzQrbWGtCTB9ECVBKOUX78K5SiqTTxg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
  };

  nativeBuildInputs = [
    cmake
    addDriverRunpath
    blueprint-compiler
    cargo
    libxml2
    makeWrapper
    meson
    ninja
    pkg-config
    python3
    protobuf # for protoc
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    appstream-glib
    blueprint-compiler
    cairo
    dbus
    desktop-file-utils
    gdk-pixbuf
    gettext
    glib
    graphene
    gtk4
    libadwaita
    libdrm
    libgbm
    pango
    sqlite
    udev
    wayland
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/missioncenter";
  doInstallCheck = true;

<<<<<<< HEAD
  dontWrapGApps = true;

  postFixup = ''
    wrapProgram $out/bin/missioncenter \
      "''${gappsWrapperArgs[@]}"

    wrapProgram $out/bin/missioncenter-magpie \
      "''${gappsWrapperArgs[@]}" \
=======
  postFixup = ''
    wrapProgram $out/bin/missioncenter-magpie \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          # Make sure libGL libvulkan can be found by dlopen()
          libGL
          libdrm
          vulkan-loader

          # NVIDIA support requires linking libnvidia-ml.so at runtime:
          # https://github.com/Syllo/nvtop/blob/3.2.0/src/extract_gpuinfo_nvidia.c#L274-L276
          addDriverRunpath.driverLink
        ]
      }"
  '';

  meta = {
    description = "Monitor your CPU, Memory, Disk, Network and GPU usage";
    homepage = "https://gitlab.com/mission-center-devs/mission-center";
    changelog = "https://gitlab.com/mission-center-devs/mission-center/-/releases/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      getchoo
    ];
    platforms = lib.platforms.linux;
    mainProgram = "missioncenter";
  };
})
