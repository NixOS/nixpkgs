{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
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
  version = "0.9.38";

  src = fetchFromGitHub {
    owner = "FastFlowLM";
    repo = "FastFlowLM";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-d9j9zgLextfpkTns6v38W0wpIJwS/CQGFlBXdrz0JaQ=";
  };

  postPatch = ''
    chmod +rw ../third_party/tokenizers-cpp/rust
    cp ${./Cargo.lock} ../third_party/tokenizers-cpp/rust/Cargo.lock

    substituteInPlace CMakeLists.txt \
      --replace-fail 'CMAKE_INSTALL_PREFIX STREQUAL "/usr"' 'TRUE'
  '';

  cargoRoot = "../third_party/tokenizers-cpp/rust";

  sourceRoot = "${finalAttrs.src.name}/src";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    cmake
    ninja
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
    "--preset linux-default"
    # fix: "CMake was unable to find a build program corresponding to "Ninja"."
    (lib.cmakeFeature "CMAKE_MAKE_PROGRAM" "ninja")

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
