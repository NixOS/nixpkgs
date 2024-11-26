{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-smi,
  clr,
  perl,
  hipify,
  gtest,
  chrpath,
  buildTests ? false,
  gpuTargets ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rccl";
  version = "5.7.1";

  outputs =
    [
      "out"
    ]
    ++ lib.optionals buildTests [
      "test"
    ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rccl";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-nFkou/kjGBmImorlPOZNTlCrxbfAYpDhgRveyoAufu8=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
    perl
    hipify
  ];

  buildInputs =
    [
      rocm-smi
      gtest
    ]
    ++ lib.optionals buildTests [
      chrpath
    ];

  cmakeFlags =
    [
      "-DCMAKE_CXX_COMPILER=hipcc"
      "-DBUILD_BFD=OFF" # Can't get it to detect bfd.h
      # Manually define CMAKE_INSTALL_<DIR>
      # See: https://github.com/NixOS/nixpkgs/pull/197838
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ]
    ++ lib.optionals (gpuTargets != [ ]) [
      "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
    ]
    ++ lib.optionals buildTests [
      "-DBUILD_TESTS=ON"
    ];

  postPatch = ''
    patchShebangs src tools

    # Really strange behavior, `#!/usr/bin/env perl` should work...
    substituteInPlace CMakeLists.txt \
      --replace "\''$ \''${hipify-perl_executable}" "${perl}/bin/perl ${hipify}/bin/hipify-perl"
  '';

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/* $test/bin
    rmdir $out/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm communication collectives library";
    homepage = "https://github.com/ROCm/rccl";
    license = with licenses; [
      bsd2
      bsd3
    ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "6.0.0";
  };
})
