{
  config,
  callPackages,
  stdenv,
  lib,
  addDriverRunpath,
  fetchFromGitHub,
  protobuf,
  protoc-gen-go,
  protoc-gen-go-grpc,
  grpc,
  openssl,
  llama-cpp,
  # needed for audio-to-text
  ffmpeg,
  cmake,
  pkg-config,
  buildGoModule,
  makeWrapper,
  ncurses,
  which,
  opencv,
  curl,

  enable_upx ? true,
  upx,

  # apply feature parameter names according to
  # https://github.com/NixOS/rfcs/pull/169

  # CPU extensions
  enable_avx ? stdenv.hostPlatform.isx86_64,
  enable_avx2 ? stdenv.hostPlatform.isx86_64,
  enable_avx512 ? stdenv.hostPlatform.avx512Support,
  enable_f16c ? stdenv.hostPlatform.isx86_64,
  enable_fma ? stdenv.hostPlatform.isx86_64,

  with_openblas ? false,
  openblas,

  with_cublas ? config.cudaSupport,
  cudaPackages,

  with_clblas ? false,
  clblast,
  ocl-icd,
  opencl-headers,

  with_vulkan ? false,

  with_tts ? true,
  onnxruntime,
  sonic,
  spdlog,
  fmt,
  espeak-ng,
  piper-tts,
}:
let
  BUILD_TYPE =
    assert
      (lib.count lib.id [
        with_openblas
        with_cublas
        with_clblas
        with_vulkan
      ]) <= 1;
    if with_openblas then
      "openblas"
    else if with_cublas then
      "cublas"
    else if with_clblas then
      "clblas"
    else
      "";

  inherit (cudaPackages)
    libcublas
    cuda_nvcc
    cuda_cccl
    cuda_cudart
    libcufft
    ;

  llama-cpp-rpc =
    (llama-cpp-grpc.overrideAttrs (prev: {
      name = "llama-cpp-rpc";
      cmakeFlags = prev.cmakeFlags ++ [
        (lib.cmakeBool "GGML_AVX" false)
        (lib.cmakeBool "GGML_AVX2" false)
        (lib.cmakeBool "GGML_AVX512" false)
        (lib.cmakeBool "GGML_FMA" false)
        (lib.cmakeBool "GGML_F16C" false)
      ];
    })).override
      {
        cudaSupport = false;
        openclSupport = false;
        blasSupport = false;
        rpcSupport = true;
        vulkanSupport = false;
      };

  llama-cpp-grpc =
    (llama-cpp.overrideAttrs (
      final: prev: {
        name = "llama-cpp-grpc";
        src = fetchFromGitHub {
          owner = "ggerganov";
          repo = "llama.cpp";
          rev = "d6d2c2ab8c8865784ba9fef37f2b2de3f2134d33";
          hash = "sha256-b9B5I3EbBFrkWc6RLXMWcCRKayyWjlGuQrogUcrISrc=";
          fetchSubmodules = true;
        };
        postPatch = prev.postPatch + ''
          cd examples
          cp -r --no-preserve=mode ${src}/backend/cpp/llama grpc-server
          cp llava/clip* llava/llava.* grpc-server
          printf "\nadd_subdirectory(grpc-server)" >> CMakeLists.txt

          cp ${src}/backend/backend.proto grpc-server
          sed -i grpc-server/CMakeLists.txt \
            -e '/get_filename_component/ s;[.\/]*backend/;;' \
            -e '$a\install(TARGETS ''${TARGET} RUNTIME)'
          cd ..
        '';
        cmakeFlags = prev.cmakeFlags ++ [
          (lib.cmakeBool "BUILD_SHARED_LIBS" false)
          (lib.cmakeBool "GGML_AVX" enable_avx)
          (lib.cmakeBool "GGML_AVX2" enable_avx2)
          (lib.cmakeBool "GGML_AVX512" enable_avx512)
          (lib.cmakeBool "GGML_FMA" enable_fma)
          (lib.cmakeBool "GGML_F16C" enable_f16c)
        ];
        buildInputs = prev.buildInputs ++ [
          protobuf # provides also abseil_cpp as propagated build input
          grpc
          openssl
          curl
        ];
      }
    )).override
      {
        cudaSupport = with_cublas;
        rocmSupport = false;
        openclSupport = with_clblas;
        blasSupport = with_openblas;
        vulkanSupport = with_vulkan;
      };

  espeak-ng' = espeak-ng.overrideAttrs (self: {
    name = "espeak-ng'";
    inherit (go-piper) src;
    sourceRoot = "${go-piper.src.name}/espeak";
    patches = [ ];
    nativeBuildInputs = [ cmake ];
    cmakeFlags = (self.cmakeFlags or [ ]) ++ [
      (lib.cmakeBool "BUILD_SHARED_LIBS" true)
      (lib.cmakeBool "USE_ASYNC" false)
      (lib.cmakeBool "USE_MBROLA" false)
      (lib.cmakeBool "USE_LIBPCAUDIO" false)
      (lib.cmakeBool "USE_KLATT" false)
      (lib.cmakeBool "USE_SPEECHPLAYER" false)
      (lib.cmakeBool "USE_LIBSONIC" false)
      (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true)
    ];
    preConfigure = null;
    postInstall = null;
  });

  piper-phonemize = stdenv.mkDerivation {
    name = "piper-phonemize";
    inherit (go-piper) src;
    sourceRoot = "${go-piper.src.name}/piper-phonemize";
    buildInputs = [
      espeak-ng'
      onnxruntime
    ];
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    cmakeFlags = [
      (lib.cmakeFeature "ONNXRUNTIME_DIR" "${onnxruntime.dev}")
      (lib.cmakeFeature "ESPEAK_NG_DIR" "${espeak-ng'}")
    ];
    passthru.espeak-ng = espeak-ng';
  };

  piper-tts' = piper-tts.overrideAttrs (self: {
    name = "piper-tts'";
    inherit (go-piper) src;
    sourceRoot = "${go-piper.src.name}/piper";
    installPhase = null;
    postInstall = ''
      cp CMakeFiles/piper.dir/src/cpp/piper.cpp.o $out/piper.o
      cd $out
      mkdir bin lib
      mv lib*so* lib/
      mv piper piper_phonemize bin/
      rm -rf cmake pkgconfig espeak-ng-data *.ort
    '';
  });

  go-piper = stdenv.mkDerivation {
    name = "go-piper";
    src = fetchFromGitHub {
      owner = "mudler";
      repo = "go-piper";
      rev = "e10ca041a885d4a8f3871d52924b47792d5e5aa0";
      hash = "sha256-Yv9LQkWwGpYdOS0FvtP0vZ0tRyBAx27sdmziBR4U4n8=";
      fetchSubmodules = true;
    };
    postUnpack = ''
      cp -r --no-preserve=mode ${piper-tts'}/* source
    '';
    postPatch = ''
      sed -i Makefile \
        -e '/CXXFLAGS *= / s;$; -DSPDLOG_FMT_EXTERNAL=1;'
    '';
    buildFlags = [ "libpiper_binding.a" ];
    buildInputs = [
      piper-tts'
      espeak-ng'
      piper-phonemize
      sonic
      fmt
      spdlog
      onnxruntime
    ];
    installPhase = ''
      cp -r --no-preserve=mode $src $out
      mkdir -p $out/piper-phonemize/pi
      cp -r --no-preserve=mode ${piper-phonemize}/share $out/piper-phonemize/pi
      cp *.a $out
    '';
  };

  # try to merge with openai-whisper-cpp in future
  whisper-cpp = effectiveStdenv.mkDerivation {
    name = "whisper-cpp";
    src = fetchFromGitHub {
      owner = "ggerganov";
      repo = "whisper.cpp";
      rev = "6266a9f9e56a5b925e9892acf650f3eb1245814d";
      hash = "sha256-y30ZccpF3SCdRGa+P3ddF1tT1KnvlI4Fexx81wZxfTk=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ]
    ++ lib.optionals with_cublas [ cuda_nvcc ];

    buildInputs =
      [ ]
      ++ lib.optionals with_cublas [
        cuda_cccl
        cuda_cudart
        libcublas
        libcufft
      ]
      ++ lib.optionals with_clblas [
        clblast
        ocl-icd
        opencl-headers
      ]
      ++ lib.optionals with_openblas [ openblas.dev ];

    cmakeFlags = [
      (lib.cmakeBool "WHISPER_CUDA" with_cublas)
      (lib.cmakeBool "WHISPER_CLBLAST" with_clblas)
      (lib.cmakeBool "WHISPER_OPENBLAS" with_openblas)
      (lib.cmakeBool "WHISPER_NO_AVX" (!enable_avx))
      (lib.cmakeBool "WHISPER_NO_AVX2" (!enable_avx2))
      (lib.cmakeBool "WHISPER_NO_FMA" (!enable_fma))
      (lib.cmakeBool "WHISPER_NO_F16C" (!enable_f16c))
      (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    ];
    postInstall = ''
      install -Dt $out/bin bin/*
    '';
  };

  bark = stdenv.mkDerivation {
    name = "bark";
    src = fetchFromGitHub {
      owner = "PABannier";
      repo = "bark.cpp";
      tag = "v1.0.0";
      hash = "sha256-wOcggRWe8lsUzEj/wqOAUlJVypgNFmit5ISs9fbwoCE=";
      fetchSubmodules = true;
    };
    installPhase = ''
      mkdir -p $out/build
      cp -ra $src/* $out
      find . \( -name '*.a' -or -name '*.c.o' \) -print0 \
        | tar cf - --null --files-from - \
        | tar xf - -C $out/build
    '';
    nativeBuildInputs = [ cmake ];
  };

  stable-diffusion = stdenv.mkDerivation {
    name = "stable-diffusion";
    src = fetchFromGitHub {
      owner = "richiejp";
      repo = "stable-diffusion.cpp";
      rev = "53e3b17eb3d0b5760ced06a1f98320b68b34aaae"; # branch cuda-fix
      hash = "sha256-z56jafOdibpX+XhRsrc7ieGbeug4bf737/UobqkpBV0=";
      fetchSubmodules = true;
    };
    installPhase = ''
      mkdir -p $out/build
      cp -ra $src/* $out
      find . \( -name '*.a' -or -name '*.c.o' \) -print0 \
        | tar cf - --null --files-from - \
        | tar xf - -C $out/build
    '';
    cmakeFlags = [
      (lib.cmakeFeature "GGML_BUILD_NUMBER" "1")
    ];
    nativeBuildInputs = [ cmake ];
    buildInputs = [ opencv ];
  };

  GO_TAGS = lib.optional with_tts "tts";

  effectiveStdenv =
    if with_cublas then
      # It's necessary to consistently use backendStdenv when building with CUDA support,
      # otherwise we get libstdc++ errors downstream.
      cudaPackages.backendStdenv
    else
      stdenv;

  pname = "local-ai";
  version = "2.28.0";
  src = fetchFromGitHub {
    owner = "go-skynet";
    repo = "LocalAI";
    tag = "v${version}";
    hash = "sha256-Hpz0dGkgasSY/FGO7mDzqsLjXut0LdQ9PUXGaURUOlY=";
  };

  prepare-sources =
    let
      cp = "cp -r --no-preserve=mode,ownership";
    in
    ''
      mkdir sources
      ${cp} ${if with_tts then go-piper else go-piper.src} sources/go-piper
      ${cp} ${whisper-cpp.src} sources/whisper.cpp
      cp ${whisper-cpp}/lib/lib*.a sources/whisper.cpp
      ${cp} ${bark} sources/bark.cpp
      ${cp} ${stable-diffusion} sources/stablediffusion-ggml.cpp
    '';

  self = buildGoModule.override { stdenv = effectiveStdenv; } {
    inherit pname version src;

    vendorHash = "sha256-1OY/y1AeL0K+vOU4Jk/cj7rToVLC9EkkNhgifB+icDM=";

    env.NIX_CFLAGS_COMPILE = " -isystem ${opencv}/include/opencv4";

    postPatch = ''
      # TODO: add silero-vad
      sed -i Makefile \
        -e '/mod download/ d' \
        -e '/^ALL_GRPC_BACKENDS+=backend-assets\/grpc\/llama-cpp-avx/ d' \
        -e '/^ALL_GRPC_BACKENDS+=backend-assets\/grpc\/llama-cpp-cuda/ d' \
        -e '/^ALL_GRPC_BACKENDS+=backend-assets\/grpc\/silero-vad/ d' \

      sed -i backend/go/image/stablediffusion-ggml/Makefile \
        -e '/^libsd/ s,$, $(COMBINED_LIB),'

    ''
    + lib.optionalString with_cublas ''
      sed -i Makefile \
        -e '/^CGO_LDFLAGS_WHISPER?=/ s;$;-L${libcufft}/lib -L${cuda_cudart}/lib;'
    '';

    postConfigure = prepare-sources + ''
      shopt -s extglob
      mkdir -p backend-assets/grpc
      cp ${llama-cpp-grpc}/bin/grpc-server backend-assets/grpc/llama-cpp-fallback
      cp ${llama-cpp-rpc}/bin/grpc-server backend-assets/grpc/llama-cpp-grpc

      mkdir -p backend/cpp/llama/llama.cpp

      mkdir -p backend-assets/util
      cp ${llama-cpp-rpc}/bin/llama-rpc-server backend-assets/util/llama-cpp-rpc-server

      cp -r --no-preserve=mode,ownership ${stable-diffusion}/build backend/go/image/stablediffusion-ggml/build

      # avoid rebuild of prebuilt make targets
      touch backend-assets/grpc/* backend-assets/util/*
      find sources -name "lib*.a" -exec touch {} +
    '';

    buildInputs =
      [ ]
      ++ lib.optionals with_cublas [
        cuda_cudart
        libcublas
        libcufft
      ]
      ++ lib.optionals with_clblas [
        clblast
        ocl-icd
        opencl-headers
      ]
      ++ lib.optionals with_openblas [ openblas.dev ]
      ++ lib.optionals with_tts go-piper.buildInputs;

    nativeBuildInputs = [
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
      makeWrapper
      ncurses # tput
      which
    ]
    ++ lib.optional enable_upx upx
    ++ lib.optionals with_cublas [ cuda_nvcc ];

    enableParallelBuilding = false;

    modBuildPhase = prepare-sources + ''
      make protogen-go
      go mod tidy -v
    '';

    proxyVendor = true;

    # should be passed as makeFlags, but build system failes with strings
    # containing spaces
    env.GO_TAGS = builtins.concatStringsSep " " GO_TAGS;

    makeFlags = [
      "VERSION=v${version}"
      "BUILD_TYPE=${BUILD_TYPE}"
    ]
    ++ lib.optional with_cublas "CUDA_LIBPATH=${cuda_cudart}/lib"
    ++ lib.optional with_tts "PIPER_CGO_CXXFLAGS=-DSPDLOG_FMT_EXTERNAL=1";

    buildPhase = ''
      runHook preBuild

      local flagsArray=(
        ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}}
        SHELL=$SHELL
      )

      # copy from Makefile:258
      make -C backend/go/image/stablediffusion-ggml libsd.a

      concatTo flagsArray makeFlags makeFlagsArray buildFlags buildFlagsArray
      echoCmd 'build flags' "''${flagsArray[@]}"
      make build "''${flagsArray[@]}"
      unset flagsArray

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dt $out/bin ${pname}

      runHook postInstall
    '';

    # patching rpath with patchelf doens't work. The executable
    # raises an segmentation fault
    postFixup =
      let
        LD_LIBRARY_PATH =
          [ ]
          ++ lib.optionals with_cublas [
            # driverLink has to be first to avoid loading the stub version of libcuda.so
            # https://github.com/NixOS/nixpkgs/issues/320145#issuecomment-2190319327
            addDriverRunpath.driverLink
            (lib.getLib libcublas)
            cuda_cudart
          ]
          ++ lib.optionals with_clblas [
            clblast
            ocl-icd
          ]
          ++ lib.optionals with_openblas [ openblas ]
          ++ lib.optionals with_tts [ piper-phonemize ]
          ++ lib.optionals (with_tts && enable_upx) [
            fmt
            spdlog
          ];
      in
      ''
        wrapProgram $out/bin/${pname} \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath LD_LIBRARY_PATH}" \
        --prefix PATH : "${ffmpeg}/bin"
      '';

    passthru.local-packages = {
      inherit
        go-piper
        llama-cpp-grpc
        whisper-cpp
        espeak-ng'
        piper-phonemize
        piper-tts'
        llama-cpp-rpc
        bark
        stable-diffusion
        ;
    };

    passthru.features = {
      inherit
        with_cublas
        with_openblas
        with_vulkan
        with_tts
        with_clblas
        ;
    };

    passthru.tests = callPackages ./tests.nix { inherit self; };
    passthru.lib = callPackages ./lib.nix { };

    meta = with lib; {
      description = "OpenAI alternative to run local LLMs, image and audio generation";
      mainProgram = "local-ai";
      homepage = "https://localai.io";
      license = licenses.mit;
      maintainers = with maintainers; [
        onny
        ck3d
      ];
      platforms = platforms.linux;
      # Doesn't build with >buildGo123Module.
      # 'cp: cannot stat 'bin/rpc-server': No such file or directory'
      broken = true;
    };
  };
in
self
