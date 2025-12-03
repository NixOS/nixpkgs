{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  abseil-cpp,
  boost,
  cryptopp,
  fuse,
  libargon2,
  protobuf,
  sqlite,
  tclap,
  _experimental-update-script-combinators,
  nix-update-script,
}:

let
  fruit = stdenv.mkDerivation (finalAttrs: {
    pname = "fruit";
    version = "3.7.1-unstable-2025-05-12";

    src = fetchFromGitHub {
      owner = "google";
      repo = "fruit";
      rev = "19f5c05466565ef507a196b33de08f1c96dd0e58";
      hash = "sha256-amBwZ/9GmW8kf70lXP0iN2G1iflJLaf3crn/Ped7Zz8=";
    };

    nativeBuildInputs = [ cmake ];

    buildInputs = [ boost ];

    cmakeFlags = [
      (lib.cmakeBool "BUILD_SHARED_LIBS" true)
      (lib.cmakeBool "FRUIT_USES_BOOST" true)
    ];

    meta = {
      description = "Dependency injection framework for C++";
      homepage = "https://github.com/google/fruit";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
    };
  });

  uni-algo = stdenv.mkDerivation (finalAttrs: {
    pname = "uni-algo";
    version = "1.2.0";

    src = fetchFromGitHub {
      owner = "uni-algo";
      repo = "uni-algo";
      tag = "v${finalAttrs.version}";
      hash = "sha256-IyQrL/DWDj87GplSGJC4iQJAzNURLh9TRko5l+EIfuU=";
    };

    nativeBuildInputs = [ cmake ];

    meta = {
      description = "Unicode Algorithms Implementation for C/C++";
      homepage = "https://github.com/uni-algo/uni-algo";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "securefs";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "netheril96";
    repo = "securefs";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ZY6FE8DCLip8p5eWqBtkVNxhGQp8zAVhkhM6kUsBZXo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    abseil-cpp
    cryptopp
    fruit
    fuse
    libargon2
    protobuf
    uni-algo
    sqlite
    tclap
  ];

  cmakeFlags = [
    (lib.cmakeBool "SECUREFS_ENABLE_INTEGRATION_TEST" false)
    (lib.cmakeBool "SECUREFS_ENABLE_UNIT_TEST" false)
    (lib.cmakeBool "SECUREFS_USE_VCPKG" false)
  ];

  passthru = {
    inherit fruit uni-algo;
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        attrPath = "securefs.fruit";
        extraArgs = [ "--version=branch" ];
      })
      (nix-update-script { attrPath = "securefs.uni-algo"; })
      (nix-update-script { })
    ];
  };

  meta = {
    homepage = "https://github.com/netheril96/securefs";
    description = "Transparent encryption filesystem";
    longDescription = ''
      Securefs is a filesystem in userspace (FUSE) that transparently encrypts
      and authenticates data stored. It is particularly designed to secure
      data stored in the cloud.
      Securefs mounts a regular directory onto a mount point. The mount point
      appears as a regular filesystem, where one can read/write/create files,
      directories and symbolic links. The underlying directory will be
      automatically updated to contain the encrypted and authenticated
      contents.
    '';
    license = with lib.licenses; [
      bsd2
      mit
    ];
    platforms = lib.platforms.unix;
    mainProgram = "securefs";
  };
})
