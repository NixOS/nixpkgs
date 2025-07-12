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

stdenv.mkDerivation (finalAttrs: {
  pname = "px4-uorb-headers";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "PX4";
    repo = "PX4-Autopilot";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true; # TODO: Unvendor libmicroxrceddsclient
    hash = "sha256-aMBa4Clqrn1NFcUhoHgAbDioIQpdNnikF7TpbviEkZI=";
  };

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
    runHook preBuild

    mkdir -p $out/include/uORB/topics
    cp -rv build/generated/uORB/topics/* $out/include/uORB/topics/

    mkdir -p $out/share/px4-uorb/msg
    cp -rv msg/* $out/share/px4-uorb/msg/

    runHook postBUild
  '';

  meta = {
    description = "Generated uORB topic headers for PX4";
    homepage = "https://docs.px4.io/main/en/middleware/uorb.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
