{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  patchelf,
  boost,
  curl,
  cargo,
  ffmpeg,
  openxr-loader,
  libuuid,
  libdrm,
  fftw,
  fftwFloat,
  fftwLongDouble,
  tokenizers-cpp,
  xrt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastflowlm";
  version = "0.9.37";

  src = fetchFromGitHub {
    owner = "FastFlowLM";
    repo = "FastFlowLM";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OXIcpvajEVdetp/I6tWI7swD36gsMBqc5oSbd9cfztU=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [ ./use-external-tokenizers.patch ];

  postPatch = ''
    # Disable symlink creation that tries to write to /usr/local/bin
    sed -i 's/if(NOT WIN32 AND NOT CMAKE_INSTALL_PREFIX/if(FALSE AND NOT CMAKE_INSTALL_PREFIX/' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    patchelf
    boost
    curl
    cargo
  ];

  buildInputs = [
    tokenizers-cpp
    tokenizers-cpp.tokenizers-c
    xrt.xdna
    stdenv.cc.cc.lib
    ffmpeg
    openxr-loader
    libuuid
    libdrm
    fftw
    fftwFloat
    fftwLongDouble
  ];

  cmakeFlags = [
    "-DTOKENIZERS_CPP_LIB_PATH=${tokenizers-cpp}/lib/libtokenizers_cpp.a"
    "-DTOKENIZERS_CPP_INCLUDE_PATH=${tokenizers-cpp}/include"
    "-DTOKENIZERS_C_LIB_PATH=${tokenizers-cpp.tokenizers-c}/lib/libtokenizers_c.a"
    "-DFLM_VERSION=${finalAttrs.version}"
    "-DNPU_VERSION=${finalAttrs.version}"
    "-DXRT_INCLUDE_DIR=${xrt.xdna}/include"
    "-DXRT_LIB_DIR=${xrt.xdna}/lib"
  ];

  env.NIX_LDFLAGS = "-L${tokenizers-cpp.tokenizers-c}/lib -ltokenizers_c";

  postFixup = ''
    # Patch RPATH of prebuilt shared libraries to include libgomp and XRT
    for lib in $out/lib/*.so; do
      patchelf --add-rpath ${stdenv.cc.cc.lib}/lib:${xrt.xdna}/lib "$lib" || true
    done
    # Create symlink for xclbins that flm expects in bin/
    ln -sf ../share/flm/xclbins $out/bin/xclbins
  '';

  meta = {
    description = "High-performance LLM inference engine for AMD Ryzen AI NPUs";
    homepage = "https://github.com/FastFlowLM/FastFlowLM";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "flm";
  };
})
