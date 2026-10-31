{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPypi,

  cmake,
  # PX4-Autopilot's own Tools/setup/requirements.txt pins "empy>=3.3,<4":
  # empy 4.0 removed the module-level em.RAW_OPT/em.BUFFERED_OPT API that
  # PX4's msg generator actually uses, in favor of a new Interpreter-based
  # API, so this is a real upstream constraint rather than a stale one to
  # bump past - use the last 3.x release instead of the (incompatible)
  # python3Packages.empy default.
  empy ? python3Packages.empy.overridePythonAttrs (old: rec {
    version = "3.3.4";
    src = fetchPypi {
      pname = "empy";
      inherit version;
      hash = "sha256-c6xJeFtgFHnfTqGKfHm8EwSop8NMArlHLPEgauiPAbM=";
    };
  }),
  heatshrink,
  jinja2 ? python3Packages.jinja2,
  kconfiglib ? python3Packages.kconfiglib,
  micro-xrce-dds-client,
  ninja,
  px4-gpsdrivers,
  # Built against the same pinned empy as above, so only one em.py ends up
  # on PYTHONPATH.
  pyros-genmsg ? python3Packages.pyros-genmsg.override { inherit empy; },
  rsync,
  symforce ? python3Packages.symforce,

  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "px4-uorb-headers";
  version = "1.17.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PX4";
    repo = "PX4-Autopilot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wE0NlWqWEWYJ+G7NB6746hxTENrxpS2Zk70yq5oY9bw=";
  };

  # PX4-Autopilot's top-level CMakeLists.txt unconditionally
  # add_subdirectory()s every module in the default px4_sitl_default module
  # list at *configure* time (not just build time) - uorb_headers itself
  # never builds or links against any of the three modules patched below,
  # but CMake still validates each one's own CMakeLists.txt as it's walked,
  # so a vendored submodule any of them reference has to be real (or
  # replaced) for `cmake -B` configure to succeed at all, even though none
  # of them are ever actually built for this derivation's one target
  # (confirmed by reproducing the configure step with and without each
  # submodule present). No other submodule is needed to configure or build
  # uorb_headers.
  #
  # Rather than vendoring the submodules (fetchSubmodules = true would pull
  # in ~30 unrelated ones just for these three), each patch makes its module
  # find_package() a real, independent nixpkgs package instead:
  #   - modules/uxrce_dds_client's ExternalProject_Add validates at
  #     *configure* time that its submodule SOURCE_DIR is an existing
  #     non-empty directory, so an empty/missing placeholder is a hard
  #     configure failure.
  #   - lib/heatshrink and drivers/gps both list files from their
  #     submodules directly as SRCS, which CMake validates exist at
  #     generate time regardless of EXCLUDE_FROM_ALL.
  patches = [
    ./find-package-microxrcedds-client.patch
    ./find-package-heatshrink.patch
    ./find-package-px4-gpsdrivers.patch
  ];

  buildInputs = [
    heatshrink
    micro-xrce-dds-client
    px4-gpsdrivers
  ];

  postPatch = ''
    cat > src/lib/version/CMakeLists.txt <<EOF
      set(version_string "${finalAttrs.version}")

      add_library(version version.c)

      target_compile_definitions(version
        PUBLIC
          PX4_BOARD_NAME="''${PX4_BOARD_NAME}"
          PX4_BOARD_LABEL="''${PX4_BOARD_LABEL}"
        PRIVATE
          BUILD_URI=''${BUILD_URI}
        )
    EOF
  '';

  nativeBuildInputs = [
    cmake
    empy
    jinja2
    kconfiglib
    ninja
    pyros-genmsg
    symforce
  ];

  cmakeFlags = [
    (lib.cmakeFeature "PX4_CONFIG" "px4_sitl_default")
  ];

  # cmakeConfigurePhase (from the cmake setup hook) cd's into $cmakeBuildDir
  # ("build") and never cd's back out, so build/installPhase both continue
  # to run from inside build/ rather than the source root.
  buildPhase = ''
    runHook preBuild

    cmake --build . --target uorb_headers

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/uORB/topics
    cp -rv uORB/topics/* $out/include/uORB/topics/

    mkdir -p $out/share/px4-uorb/msg
    cp -rv ../msg/* $out/share/px4-uorb/msg/

    runHook postInstall
  '';

  meta = {
    description = "Generated uORB topic headers for PX4";
    homepage = "https://docs.px4.io/main/en/middleware/uorb.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
