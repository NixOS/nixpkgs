{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  empy ? python3Packages.empy,
  jinja2 ? python3Packages.jinja2,
  kconfiglib ? python3Packages.kconfiglib,
  ninja,
  rsync,
  symforce ? python3Packages.symforce,

  python3Packages,
}:

let
  # PX4-Autopilot vendors libmicroxrceddsclient as a git submodule at
  # src/modules/uxrce_dds_client/Micro-XRCE-DDS-Client. uorb_headers itself
  # never builds or links against this module, but CMake's top-level
  # configure (not just build) unconditionally add_subdirectory()s every
  # module in the default px4_sitl_default module list, including
  # modules/uxrce_dds_client, whose CMakeLists.txt calls ExternalProject_Add
  # with SOURCE_DIR pointing at this submodule. ExternalProject_Add
  # validates at *configure* time that SOURCE_DIR is an existing non-empty
  # directory, so an empty/missing submodule placeholder is a hard
  # `cmake -B` configure failure, not just a build failure -- confirmed by
  # reproducing the configure step both with and without this submodule
  # present. No other submodule is needed to configure or build
  # uorb_headers, so only this one is fetched here instead of using
  # fetchSubmodules = true on the whole PX4-Autopilot checkout.
  microxrceddsclient = fetchFromGitHub {
    owner = "PX4";
    repo = "Micro-XRCE-DDS-Client";
    rev = "711aef423edd1820347b866d1e4164832df35d04"; # px4 branch, pinned to the submodule commit PX4-Autopilot v1.17.0 references
    hash = "sha256-ZnmhneL9Kgg+Tt6nBGveuBpowPYoTco6Leav/XxsEPY=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "px4-uorb-headers";
  version = "1.17.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PX4";
    repo = "PX4-Autopilot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-odGVL3MlJuFqq10eSGInx8Ixjl6qj0/oUlIgYTg4BZw=";
  };

  postPatch = ''
    rmdir src/modules/uxrce_dds_client/Micro-XRCE-DDS-Client
    cp -r --no-preserve=mode ${microxrceddsclient} src/modules/uxrce_dds_client/Micro-XRCE-DDS-Client

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
    symforce
  ];

  cmakeFlags = [
    (lib.cmakeFeature "PX4_CONFIG" "px4_sitl_default")
  ];

  buildPhase = ''
    runHook preBuild

    cmake -Bbuild -S. $CMAKE_FLAGS
    cmake --build build --target uorb_headers

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/uORB/topics
    cp -rv build/generated/uORB/topics/* $out/include/uORB/topics/

    mkdir -p $out/share/px4-uorb/msg
    cp -rv msg/* $out/share/px4-uorb/msg/

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
