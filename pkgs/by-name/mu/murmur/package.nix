{
  lib,
  avahi,
  boost,
  cmake,
  mumble,
  libcap,
  nixosTests,
  pkg-config,
  poco,
  protobuf,
  python3,
  qt5,
  stdenv,
  zeroc-ice,
  iceSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit (mumble) version src;
  pname = "murmur";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    avahi
    boost
    libcap
    poco
    protobuf
  ] ++ lib.optional iceSupport zeroc-ice;

  cmakeFlags =
    [
      "-D g15=OFF"
      "-D CMAKE_CXX_STANDARD=17" # protobuf >22 requires C++ 17
      "-D client=OFF"
    ]
    ++ (
      if iceSupport then
        [
          "-D Ice_HOME=${lib.getDev zeroc-ice};${lib.getLib zeroc-ice}"
          "-D CMAKE_PREFIX_PATH=${lib.getDev zeroc-ice};${lib.getLib zeroc-ice}"
          "-D Ice_SLICE_DIR=${lib.getDev zeroc-ice}/share/ice/slice"
        ]
      else
        [ "-D ice=OFF" ]
    );

  preConfigure = ''
    patchShebangs scripts
  '';

  passthru.tests.connectivity = nixosTests.mumble;

  meta = {
    description = "Low-latency, high quality voice chat software";
    homepage = "https://mumble.info";
    license = lib.licenses.bsd3;
    mainProgram = "mumble-server";
    maintainers = with lib.maintainers; [
      felixsinger
      lilacious
    ];
    platforms = lib.platforms.linux;
  };
})
