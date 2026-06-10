{
  lib,
  stdenv_32bit,
  fetchFromGitHub,
  pkg-config,
  qt5,
  cmake,
  ninja,
  avahi,
  boost,
  protobuf,
  python3,
  nixosTests,
  poco,
  microsoft-gsl,
  nlohmann_json,
  makeBinaryWrapper,
}:

let
  version = "1.5.857";
in
stdenv_32bit.mkDerivation {
  pname = "mumble-overlay";
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
  ++ lib.optionals stdenv_32bit.hostPlatform.isLinux [ avahi ];

  cmakeFlags = [
    "-D g15=OFF"
    "-D CMAKE_CXX_STANDARD=17" # protobuf >22 requires C++ 17
    "-D BUILD_NUMBER=${lib.versions.patch version}"
    "-D CMAKE_UNITY_BUILD=ON" # Upstream uses this in their build pipeline to speed up builds
    "-D bundled-gsl=OFF"
    "-D bundled-json=OFF"
    "-D warnings-as-errors=OFF" # protobuf 34.x `[[nodiscard]]` workaround https://github.com/mumble-voip/mumble/issues/7102
    "-D server=OFF"
    "-D client=OFF"
    "-D overlay=ON"
  ];

  preConfigure = ''
    patchShebangs scripts
  '';

  passthru.tests.connectivity = nixosTests.mumble;

  meta = {
    description = "Low-latency, high quality voice chat software";
    homepage = "https://mumble.info";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      felixsinger
      hax404
      lilacious
    ];
    platforms = lib.platforms.linux;
  };
}
