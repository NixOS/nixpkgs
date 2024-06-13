{ config
, stdenv
, lib
, fetchFromGitHub
, autoAddDriverRunpath
, cmake
, glibc_multi
, glibc
, git
, pkg-config
, pkgs
, cudaPackages ? {}
, withCuda ? config.cudaSupport
}:

let
  inherit (lib.lists) optionals;
  inherit (lib.strings) cmakeBool cmakeFeature optionalString;
  inherit (cudaPackages) cuda_cudart cuda_nvcc cudaOlder libcublas libcurand;
  hwloc = pkgs.hwloc.overrideAttrs (prevAttrs: {
    configureFlags = prevAttrs.configureFlags ++ [ "--enable-static" ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "firestarter";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "tud-zih-energy";
    repo = "FIRESTARTER";
    rev = "v${finalAttrs.version}";
    sha256 = "1ik6j1lw5nldj4i3lllrywqg54m9i2vxkxsb2zr4q0d2rfywhn23";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ] ++ optionals withCuda [ autoAddDriverRunpath cuda_nvcc ];

  buildInputs =
    [ hwloc ]
    ++ optionals (!withCuda) [ glibc.static ]
    ++ optionals withCuda [ glibc_multi cuda_cudart libcublas libcurand ];

  cudaEnableCmakeFindCudaToolkitSupport = withCuda;

  cmakeFlags = [
    (cmakeBool "FIRESTARTER_BUILD_HWLOC" false)
    (cmakeBool "CMAKE_C_COMPILER_WORKS" true)
    (cmakeBool "CMAKE_CXX_COMPILER_WORKS" true)
  ] ++ optionals withCuda [
    (cmakeFeature "FIRESTARTER_BUILD_TYPE" "FIRESTARTER_CUDA")
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp src/FIRESTARTER${optionalString withCuda "_CUDA"} $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    broken =
      (stdenv.isLinux && stdenv.isAarch64) ||
      # Depends on CUDA redistributables, only available from 11.4.
      (withCuda && cudaOlder "11.4");
    homepage = "https://tu-dresden.de/zih/forschung/projekte/firestarter";
    description = "Processor Stress Test Utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro marenz ];
    license = licenses.gpl3;
    mainProgram = "FIRESTARTER";
  };
})
