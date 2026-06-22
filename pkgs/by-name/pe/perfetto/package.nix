{
  fetchFromGitHub,
  fetchgit,
  gcc,
  gn,
  lib,
  ninja,
  pkgsBuildBuild,
  python3,
  clangStdenv,
}:
let
  abseil-cpp = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "20250512.1";
    hash = "sha256-eB7OqTO9Vwts9nYQ/Mdq0Ds4T1KgmmpYdzU09VPWOhk=";
  };
  android-core = fetchgit {
    url = "https://android.googlesource.com/platform/system/core.git";
    rev = "9e6cef7f07d8c11b3ea820938aeb7ff2e9dbaa52";
    hash = "sha256-jwqwPCy8+l0THSQNMQCFGoa7fRzE0Ry4EspQiz3EG6g=";
  };
  android-libbase = fetchgit {
    url = "https://android.googlesource.com/platform/system/libbase.git";
    rev = "18c2bd4f3607cb300bb96e543df91dfdda6a9655";
    hash = "sha256-zxMxHUccmcE92/cro/S1FiekS9XhP8l87ItVSJzU2cc=";
  };
  android-libprocinfo = fetchgit {
    url = "https://android.googlesource.com/platform/system/libprocinfo.git";
    rev = "fd214c13ededecae97a3b15b5fccc8925a749a84";
    hash = "sha256-basj7wEo35oFHpeiyflxd/HNodzo5vInep1WMInp7Vg=";
  };
  android-logging = fetchgit {
    url = "https://android.googlesource.com/platform/system/logging.git";
    rev = "da4d6df49d1d6c971be508dcde18e8b00bb74581";
    hash = "sha256-mFylFFUEY8CmydIJPISAI41x3d0RxLtwGapGdNSucKE=";
  };
  android-unwinding = fetchgit {
    url = "https://android.googlesource.com/platform/system/unwinding.git";
    rev = "4b59ea8471e89d01300481a92de3230b79b6d7c7";
    hash = "sha256-zpZfzUTmuRt4Fm75mzo/MnKm8+sMmoTObauVlTwwUoo=";
  };
  bionic = fetchgit {
    url = "https://android.googlesource.com/platform/bionic.git";
    rev = "a0d0355105cb9d4a4b5384897448676133d7b8e2";
    hash = "sha256-AcJSu2iQ+sUMmGQjxmZVva2ApFWzcC6CA6wmZn9yqjY=";
  };
  lzma = fetchgit {
    url = "https://android.googlesource.com/platform/external/lzma.git";
    rev = "7851dce6f4ca17f5caa1c93a4e0a45686b1d56c3";
    hash = "sha256-VLqGciCmUUjGpGgKgVkzOZ7odnSUuU/3Gz8Y6V+cAWU=";
  };
  protobuf = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf";
    rev = "v31.1";
    hash = "sha256-E8q8XupOXoCFpXyGNHArfBmVm6ebfDgaJlJyvMqpveU=";
  };
  re2 = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = "927f5d53caf8111721e734cf24724686bb745f55";
    hash = "sha256-0J1HVk+eR7VN0ymucW9dNlT36j16XIfCzcs1EVyEIEU=";
  };
  zlib = fetchgit {
    url = "https://chromium.googlesource.com/chromium/src/third_party/zlib.git";
    rev = "6f9b4e61924021237d474569027cfb8ac7933ee6";
    hash = "sha256-uAQHAAA400hGEqsqHA6mt+SttSpY0km/GG26aUsCzqo=";
  };
  zstd = fetchgit {
    url = "https://android.googlesource.com/platform/external/zstd.git";
    rev = "77211fcc5e08c781734a386402ada93d0d18d093";
    hash = "sha256-3RMhCoK4TSQTxRNAUdf7z/NU5TWlU0B4ZkQzGUPmnec=";
  };
in
clangStdenv.mkDerivation (finalAttrs: rec {
  pname = "perfetto";
  version = "v55.1";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "perfetto";
    rev = version;
    hash = "sha256-Sjqy4Cp1ASz1ZBi7eG3/XvJVq64VJXRxoRmiGjIJod8=";
  };

  nativeBuildInputs = [
    pkgsBuildBuild.clangStdenv.cc
    gn
    ninja
    python3
  ];

  patches = [
    # https://github.com/google/perfetto/pull/5871
    ./0001-perf-allocate-Unwinder-on-the-heap-5871.patch
    # https://github.com/google/perfetto/pull/5914
    ./0001-Fix-musl-build.patch
    # https://github.com/google/perfetto/pull/5915
    ./0001-gn-Simplify-logic-for-finding-Clang-resource-directo.patch
    # https://github.com/google/perfetto/pull/5916
    ./0002-gn-Stop-passing-Werror-in-non-hermetic-builds.patch
  ];

  postPatch = ''
    ln -s ${abseil-cpp} buildtools/abseil-cpp
    ln -s ${android-core} buildtools/android-core
    ln -s ${android-libbase} buildtools/android-libbase
    ln -s ${android-libprocinfo} buildtools/android-libprocinfo
    ln -s ${android-logging} buildtools/android-logging
    ln -s ${android-unwinding} buildtools/android-unwinding
    ln -s ${bionic} buildtools/bionic
    ln -s ${lzma} buildtools/lzma
    ln -s ${protobuf} buildtools/protobuf
    ln -s ${re2} buildtools/re2
    ln -s ${zlib} buildtools/zlib
    ln -s ${zstd} buildtools/zstd
  '';

  configurePhase = ''
    runHook preConfigure
    gn gen out --args='
      is_debug=false
      is_hermetic_clang=false
      use_custom_libcxx=false
      skip_buildtools_check=true
      ${lib.optionalString (clangStdenv.buildPlatform != clangStdenv.hostPlatform) ''
        target_triplet="${clangStdenv.hostPlatform.config}"
        target_ar="${clangStdenv.hostPlatform.config}-ar"
        target_cc="${clangStdenv.hostPlatform.config}-clang"
        target_cxx="${clangStdenv.hostPlatform.config}-clang++"
        target_strip="${clangStdenv.hostPlatform.config}-strip"
      ''}
    '
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ninja -C out tracebox
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp out/tracebox $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Performance instrumentation and logging framework";
    homepage = "https://perfetto.dev/";
    downloadPage = "https://github.com/google/perfetto";
    license = lib.licenses.asl20;
    mainProgram = "tracebox";
    maintainers = [ lib.maintainers.pcc ];
    platforms = lib.platforms.all;
  };
})
