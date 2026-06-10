{
  lib,
  stdenv,
  config,
  fetchFromGitHub,
  pkg-config,
  qt5,
  cmake,
  ninja,
  # avahi-compat is used to avoid pulling the full avahi (and its dbus dependency)
  avahi-compat,
  boost,
  protobuf,
  libcap,
  python3,
  nixosTests,
  poco,
  microsoft-gsl,
  nlohmann_json,
  makeBinaryWrapper,
  iceSupport ? config.murmur.iceSupport or true,
  zeroc-ice,
}:

let
  version = "1.5.857";
in
stdenv.mkDerivation {
  pname = "murmur";
  inherit version;

  # Needs submodules
  src = fetchFromGitHub {
    owner = "mumble-voip";
    repo = "mumble";
    tag = "v${version}";
    hash = "sha256-4ySak2nzT8p48waMgBc9kLrvFB8716e7p0G4trzuh1k=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    qt5.wrapQtAppsHook
    qt5.qttools
    makeBinaryWrapper
  ];

  buildInputs = [
    boost
    poco
    protobuf
    microsoft-gsl
    nlohmann_json
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ avahi-compat ]
  ++ [ libcap ]
  ++ lib.optional iceSupport zeroc-ice;

  cmakeFlags = [
    "-D g15=OFF"
    "-D CMAKE_CXX_STANDARD=17" # protobuf >22 requires C++ 17
    "-D BUILD_NUMBER=${lib.versions.patch version}"
    "-D CMAKE_UNITY_BUILD=ON" # Upstream uses this in their build pipeline to speed up builds
    "-D bundled-gsl=OFF"
    "-D bundled-json=OFF"
    "-D warnings-as-errors=OFF" # protobuf 34.x `[[nodiscard]]` workaround https://github.com/mumble-voip/mumble/issues/7102
    "-D client=OFF"
    (lib.cmakeBool "ice" iceSupport)
  ]
  ++ lib.optionals iceSupport [
    "-D Ice_HOME=${lib.getDev zeroc-ice};${lib.getLib zeroc-ice}"
    "-D Ice_SLICE_DIR=${lib.getDev zeroc-ice}/share/ice/slice"
  ];

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
      hax404
      lilacious
    ];
    platforms = lib.platforms.linux;
  };
}
