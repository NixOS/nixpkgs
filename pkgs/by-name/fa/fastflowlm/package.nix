{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  rustPlatform,
  cargo,
  rustc,
  autoPatchelfHook,
  # doxygen,
  boost188,
  curl,
  fftw,
  fftwFloat,
  fftwLongDouble,
  ffmpeg,
  xrt,
  libdrm,
  libuuid,
  libgcc,
  xrt-lib-with-xdna,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastflowlm";
  version = "0.9.34-unstable-2026-02-28";

  src = fetchFromGitHub {
    owner = "FastFlowLM";
    repo = "FastFlowLM";
    rev = "bac4f5e672bd2917089fb21b5ebf4cd9f67eeaec";
    fetchSubmodules = true;
    hash = "sha256-MHKjS3bI/u14FRKwKdOkC0122fqqAnFDi70I9dLP7KQ=";
  };

  postPatch = ''
    chmod +rw ../third_party/tokenizers-cpp/rust
    cp ${./Cargo.lock} ../third_party/tokenizers-cpp/rust/Cargo.lock

    substituteInPlace CMakeLists.txt \
      --replace-fail 'CMAKE_INSTALL_PREFIX STREQUAL "/usr"' 'TRUE'
  '';

  cargoRoot = "../third_party/tokenizers-cpp/rust";

  sourceRoot = "${finalAttrs.src.name}/src";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      postPatch
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-lpuGPco7P4k6T5wtEDzhXn6DJqiM3U/DiUhrsae9NuI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    autoPatchelfHook # add libgcc
  ];

  buildInputs = [
    boost188
    curl
    fftw
    fftwFloat
    fftwLongDouble
    ffmpeg
    xrt
    libdrm
    libuuid
    libgcc
  ];

  cmakeFlags = [
    (lib.cmakeFeature "XRT_INCLUDE_DIR" "${lib.getDev xrt}/include")
    (lib.cmakeFeature "XRT_LIB_DIR" "${xrt-lib-with-xdna}/lib")

    # CMake didn't set this default value so the program
    # doesn't know where to find XCLBIN (to remove in future release?)
    (lib.cmakeFeature "CMAKE_XCLBIN_PREFIX" "${placeholder "out"}/share/flm")
  ];

  postInstall = ''
    rm -r $out/{lib/cmake,include}
  '';

  meta = {
    description = "Run LLMs on AMD Ryzen AI NPUs in minutes";
    homepage = "https://fastflowlm.com";
    license = with lib.licenses; [
      mit
      unfree # for blobs
    ];
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "flm";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
