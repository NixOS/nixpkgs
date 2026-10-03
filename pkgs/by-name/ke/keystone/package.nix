{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  python3,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keystone";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "keystone-engine";
    repo = "keystone";
    rev = finalAttrs.version;
    hash = "sha256-ynXbE22PTx8VJNQGqE2twBiGpLDOU0TNeAItrAINDQg=";
  };

  patches = [
    # Patches from https://github.com/keystone-engine/keystone/pull/593
    ./gcc15.patch
    ./cmake-3.10.patch
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # TODO: could be replaced by setting CMAKE_INSTALL_NAME_DIR?
    fixDarwinDylibNames
  ];

  meta = {
    description = "Lightweight multi-platform, multi-architecture assembler framework";
    homepage = "https://www.keystone-engine.org";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "kstool";
    platforms = lib.platforms.unix;
  };
})
