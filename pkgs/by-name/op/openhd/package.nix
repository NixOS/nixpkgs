{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libv4l,
  gst_all_1,
  libpcap,
  libsodium,
  lib,
  nlohmann_json,
  spdlog,
  poco,
  withSDL2 ? true,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "OpenHD";
  version = "2.6.0-unstable-2025-10-22";

  src = fetchFromGitHub {
    owner = "OpenHD";
    repo = "OpenHD";
    rev = "7626570e24151624351bf8a700ee88e25908a609";
    hash = "sha256-kVxvqPgQcEvsqcrjZ4mx7L0nCs1UFxppV5BH42/3ERw=";
  };

  wifibroadcastSrc = fetchFromGitHub {
    owner = "OpenHD";
    repo = "wifibroadcast";
    rev = "99e53e7ea6dfafff85999504481d7cf26e3ee749";
    hash = "sha256-rkpFCLWQ8VtINhq0ts5x6o1odpFFQ9RCKVJIrHkDGFk=";
  };

  mavlinkHeadersSrc = fetchFromGitHub {
    owner = "OpenHD";
    repo = "mavlink-headers";
    rev = "a34e186e2ec6c6a2add840254691a6719606e189";
    hash = "sha256-s4hIsLhXIaitIwQE6tgJEtHVYeqpP5LnuNNxVrrIJfY=";
  };

  sourceRoot = "${finalAttrs.src.name}/OpenHD";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    libpcap
    libsodium
    libv4l
    nlohmann_json
    poco
    spdlog.dev
  ]
  ++ lib.optionals withSDL2 [ SDL2 ];

  patches = [ ./CMakeLists.patch ];

  postPatch = ''
    echo "Injecting wifibroadcast source to the expected location ..."
    ln -s ${finalAttrs.wifibroadcastSrc} ohd_common/lib/wifibroadcast
    substituteInPlace "ohd_interface/CMakeLists.txt" \
      --replace-fail \
          'include(lib/wifibroadcast/wifibroadcast/WBLib.cmake)' \
          'include("''${CMAKE_SOURCE_DIR}/ohd_common/lib/wifibroadcast/wifibroadcast/WBLib.cmake")'

    echo "Injecting mavlink-headers source to the expected location ..."
    # Doesn't like this to be a symlink
    mkdir -p ohd_telemetry/lib/mavlink-headers
    cp -r ${finalAttrs.mavlinkHeadersSrc}/* ohd_telemetry/lib/mavlink-headers/
  '';

  meta = {
    mainProgram = "openhd";
    longDescription = ''
      OpenHD is a suite of software designed for long-range video transmission,
      telemetry, and RC control.
    '';
    homepage = "https://openhdfpv.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ marijanp ];
    platforms = lib.platforms.linux;
  };
})
