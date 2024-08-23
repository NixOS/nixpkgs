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

  enable_upx ? true,
  upx,

  # apply feature parameter names according to
  # https://github.com/NixOS/rfcs/pull/169

  # CPU extensions
  enable_avx ? true,
  enable_avx2 ? true,
  enable_avx512 ? stdenv.hostPlatform.avx512Support,
  enable_f16c ? true,
  enable_fma ? true,

  with_openblas ? false,
  openblas,

  with_cublas ? config.cudaSupport,
  cudaPackages,

  with_clblas ? false,
  clblast,
  ocl-icd,
  opencl-headers,

  with_tinydream ? false, # do not compile with cublas
  ncnn,

  with_stablediffusion ? true,
  opencv,

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

  go-llama = effectiveStdenv.mkDerivation {
    name = "go-llama";
    src = fetchFromGitHub {
      owner = "go-skynet";
      repo = "go-llama.cpp";
      rev = "2b57a8ae43e4699d3dc5d1496a1ccd42922993be";
      hash = "sha256-D6SEg5pPcswGyKAmF4QTJP6/Y1vjRr7m7REguag+too=";
      fetchSubmodules = true;
    };
    buildFlags = [
      "libbinding.a"
      "BUILD_TYPE=${BUILD_TYPE}"
    ];

    buildInputs =
      [ ]
      ++ lib.optionals with_cublas [
        cuda_cccl
        cuda_cudart
        libcublas
      ]
      ++ lib.optionals with_clblas [
        clblast
        ocl-icd
        opencl-headers
      ]
      ++ lib.optionals with_openblas [ openblas.dev ];

    nativeBuildInputs = [ cmake ] ++ lib.optionals with_cublas [ cuda_nvcc ];

    dontUseCmakeConfigure = true;

    installPhase = ''
      mkdir $out
      tar cf - --exclude=build --exclude=CMakeFiles --exclude="*.o" . \
        | tar xf - -C $out
    '';
  };

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
      };

  llama-cpp-grpc =
    (llama-cpp.overrideAttrs (
      final: prev: {
        name = "llama-cpp-grpc";
        src = fetchFromGitHub {
          owner = "ggerganov";
          repo = "llama.cpp";
          rev = "ed9d2854c9de4ae1f448334294e61167b04bec2a";
          hash = "sha256-Xu2h9Zu+Q9utfFFmDWBOEu/EXth4xWRNoTMvPF5Fo/A=";
          fetchSubmodules = true;
        };
        postPatch =
          prev.postPatch
          + ''
            cd examples
            cp -r --no-preserve=mode ${src}/backend/cpp/llama grpc-server
            cp llava/clip.* llava/llava.* grpc-server
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
        ];
      }
    )).override
      {
        cudaSupport = with_cublas;
        rocmSupport = false;
        openclSupport = with_clblas;
        blasSupport = with_openblas;
      };

  gpt4all = stdenv.mkDerivation {
    name = "gpt4all";
    src = fetchFromGitHub {
      owner = "nomic-ai";
      repo = "gpt4all";
      rev = "27a8b020c36b0df8f8b82a252d261cda47cf44b8";
      hash = "sha256-djq1eK6ncvhkO3MNDgasDBUY/7WWcmZt/GJsHAulLdI=";
      fetchSubmodules = true;
    };
    makeFlags = [ "-C gpt4all-bindings/golang" ];
    buildFlags = [ "libgpt4all.a" ];
    dontUseCmakeConfigure = true;
    nativeBuildInputs = [ cmake ];
    installPhase = ''
      mkdir $out
      tar cf - --exclude=CMakeFiles . \
        | tar xf - -C $out
    '';
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

  piper-tts' = (piper-tts.override { inherit piper-phonemize; }).overrideAttrs (self: {
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
      rev = "9d0100873a7dbb0824dfea40e8cec70a1b110759";
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

  go-rwkv = stdenv.mkDerivation {
    name = "go-rwkv";
    src = fetchFromGitHub {
      owner = "donomii";
      repo = "go-rwkv.cpp";
      rev = "661e7ae26d442f5cfebd2a0881b44e8c55949ec6";
      hash = "sha256-byTNZQSnt7qpBMng3ANJmpISh3GJiz+F15UqfXaz6nQ=";
      fetchSubmodules = true;
    };
    buildFlags = [ "librwkv.a" ];
    dontUseCmakeConfigure = true;
    nativeBuildInputs = [ cmake ];
    installPhase = ''
      cp -r --no-preserve=mode $src $out
      cp *.a $out
    '';
  };

  # try to merge with openai-whisper-cpp in future
  whisper-cpp = effectiveStdenv.mkDerivation {
    name = "whisper-cpp";
    src = fetchFromGitHub {
      owner = "ggerganov";
      repo = "whisper.cpp";
      rev = "6739eb83c3ca5cf40d24c6fe8442a761a1eb6248";
      hash = "sha256-1yDdJVjIwYDJKn93zn4xOJXMoDTqaG2TvakjdHIMCxk=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ] ++ lib.optionals with_cublas [ cuda_nvcc ];

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

  go-bert = stdenv.mkDerivation {
    name = "go-bert";
    src = fetchFromGitHub {
      owner = "go-skynet";
      repo = "go-bert.cpp";
      rev = "710044b124545415f555e4260d16b146c725a6e4";
      hash = "sha256-UNrs3unYjvSzCVaVISFFBDD+s37lmN6/7ajmGNcYgrU=";
      fetchSubmodules = true;
    };
    buildFlags = [ "libgobert.a" ];
    dontUseCmakeConfigure = true;
    nativeBuildInputs = [ cmake ];
    env.NIX_CFLAGS_COMPILE = "-Wformat";
    installPhase = ''
      cp -r --no-preserve=mode $src $out
      cp *.a $out
    '';
  };

  go-stable-diffusion = stdenv.mkDerivation {
    name = "go-stable-diffusion";
    src = fetchFromGitHub {
      owner = "mudler";
      repo = "go-stable-diffusion";
      rev = "4a3cd6aeae6f66ee57eae9a0075f8c58c3a6a38f";
      hash = "sha256-KXUvMP6cDyWib4rG0RmVRm3pgrdsfKXaH3k0v5/mTe8=";
      fetchSubmodules = true;
    };
    buildFlags = [ "libstablediffusion.a" ];
    dontUseCmakeConfigure = true;
    nativeBuildInputs = [ cmake ];
    buildInputs = [ opencv ];
    env.NIX_CFLAGS_COMPILE = " -isystem ${opencv}/include/opencv4";
    installPhase = ''
      mkdir $out
      tar cf - --exclude=CMakeFiles --exclude="*.o" --exclude="*.so" --exclude="*.so.*" . \
        | tar xf - -C $out
    '';
  };

  go-tiny-dream-ncnn = ncnn.overrideAttrs (self: {
    name = "go-tiny-dream-ncnn";
    inherit (go-tiny-dream) src;
    sourceRoot = "${go-tiny-dream.src.name}/ncnn";
    cmakeFlags = self.cmakeFlags ++ [
      (lib.cmakeBool "NCNN_SHARED_LIB" false)
      (lib.cmakeBool "NCNN_OPENMP" false)
      (lib.cmakeBool "NCNN_VULKAN" false)
      (lib.cmakeBool "NCNN_AVX" enable_avx)
      (lib.cmakeBool "NCNN_AVX2" enable_avx2)
      (lib.cmakeBool "NCNN_AVX512" enable_avx512)
      (lib.cmakeBool "NCNN_FMA" enable_fma)
      (lib.cmakeBool "NCNN_F16C" enable_f16c)
    ];
  });

  go-tiny-dream = effectiveStdenv.mkDerivation {
    name = "go-tiny-dream";
    src = fetchFromGitHub {
      owner = "M0Rf30";
      repo = "go-tiny-dream";
      rev = "c04fa463ace9d9a6464313aa5f9cd0f953b6c057";
      hash = "sha256-uow3vbAI4F/fTGjYOKOLqTpKq7NgGYSZhGlEhn7h6s0=";
      fetchSubmodules = true;
    };
    postUnpack = ''
      rm -rf source/ncnn
      mkdir -p source/ncnn/build/src
      cp -r --no-preserve=mode ${go-tiny-dream-ncnn}/lib/. ${go-tiny-dream-ncnn}/include/. source/ncnn/build/src
    '';
    buildFlags = [ "libtinydream.a" ];
    installPhase = ''
      mkdir $out
      tar cf - --exclude="*.o" . \
        | tar xf - -C $out
    '';
    meta.broken = lib.versionOlder go-tiny-dream.stdenv.cc.version "13";
  };

  GO_TAGS =
    lib.optional with_tinydream "tinydream"
    ++ lib.optional with_tts "tts"
    ++ lib.optional with_stablediffusion "stablediffusion";

  effectiveStdenv =
    if with_cublas then
      # It's necessary to consistently use backendStdenv when building with CUDA support,
      # otherwise we get libstdc++ errors downstream.
      cudaPackages.backendStdenv
    else
      stdenv;

  pname = "local-ai";
  version = "2.19.4";
  src = fetchFromGitHub {
    owner = "go-skynet";
    repo = "LocalAI";
    rev = "v${version}";
    hash = "sha256-aKq6/DI+4+BvIEw6eONqPr3mZXuz7rMFN+FBypVj0Gc=";
  };

  prepare-sources =
    let
      cp = "cp -r --no-preserve=mode,ownership";
    in
    ''
      mkdir sources
      ${cp} ${go-llama} sources/go-llama.cpp
      ${cp} ${gpt4all} sources/gpt4all
      ${cp} ${if with_tts then go-piper else go-piper.src} sources/go-piper
      ${cp} ${go-rwkv} sources/go-rwkv.cpp
      ${cp} ${whisper-cpp.src} sources/whisper.cpp
      cp ${whisper-cpp}/lib/lib*.a sources/whisper.cpp
      ${cp} ${go-bert} sources/go-bert.cpp
      ${cp} ${
        if with_stablediffusion then go-stable-diffusion else go-stable-diffusion.src
      } sources/go-stable-diffusion
      ${cp} ${if with_tinydream then go-tiny-dream else go-tiny-dream.src} sources/go-tiny-dream
    '';

  self = buildGoModule.override { stdenv = effectiveStdenv; } {
    inherit pname version src;

    vendorHash = "sha256-HEKE75+ixuNbM+KEuhbQQ/NYYEzVlGYOttPavftWKhk=";

    env.NIX_CFLAGS_COMPILE = lib.optionalString with_stablediffusion " -isystem ${opencv}/include/opencv4";

    postPatch =
      ''
        sed -i Makefile \
          -e '/mod download/ d' \
          -e '/^ALL_GRPC_BACKENDS+=backend-assets\/grpc\/llama-cpp-fallback/ d' \
          -e '/^ALL_GRPC_BACKENDS+=backend-assets\/grpc\/llama-cpp-avx/ d' \
          -e '/^ALL_GRPC_BACKENDS+=backend-assets\/grpc\/llama-cpp-cuda/ d' \

      ''
      + lib.optionalString with_cublas ''
        sed -i Makefile \
          -e '/^CGO_LDFLAGS_WHISPER?=/ s;$;-L${libcufft}/lib -L${cuda_cudart}/lib;'
      '';

    postConfigure =
      prepare-sources
      + ''
        shopt -s extglob
        mkdir -p backend-assets/grpc
        cp ${llama-cpp-grpc}/bin/grpc-server backend-assets/grpc/llama-cpp-avx2
        cp ${llama-cpp-rpc}/bin/grpc-server backend-assets/grpc/llama-cpp-grpc

        mkdir -p backend/cpp/llama/llama.cpp

        mkdir -p backend-assets/util
        cp ${llama-cpp-rpc}/bin/llama-rpc-server backend-assets/util/llama-cpp-rpc-server

        # avoid rebuild of prebuilt make targets
        touch backend-assets/grpc/* backend-assets/util/* sources/**/lib*.a
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
      ++ lib.optionals with_stablediffusion go-stable-diffusion.buildInputs
      ++ lib.optionals with_tts go-piper.buildInputs;

    nativeBuildInputs = [
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
      makeWrapper
      ncurses # tput
      which
    ] ++ lib.optional enable_upx upx ++ lib.optionals with_cublas [ cuda_nvcc ];

    enableParallelBuilding = false;

    modBuildPhase =
      prepare-sources
      + ''
        make protogen-go
        go mod tidy -v
      '';

    proxyVendor = true;

    # should be passed as makeFlags, but build system failes with strings
    # containing spaces
    env.GO_TAGS = builtins.concatStringsSep " " GO_TAGS;

    makeFlags =
      [
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

    # patching rpath with patchelf doens't work. The execuable
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
        go-tiny-dream
        go-rwkv
        go-bert
        go-llama
        gpt4all
        go-piper
        llama-cpp-grpc
        whisper-cpp
        go-tiny-dream-ncnn
        espeak-ng'
        piper-phonemize
        piper-tts'
        llama-cpp-rpc
        ;
    };

    passthru.features = {
      inherit
        with_cublas
        with_openblas
        with_tts
        with_stablediffusion
        with_tinydream
        with_clblas
        ;
    };

    passthru.tests = callPackages ./tests.nix { inherit self; };
    passthru.lib = callPackages ./lib.nix { };

    meta = with lib; {
      description = "OpenAI alternative to run local LLMs, image and audio generation";
      homepage = "https://localai.io";
      license = licenses.mit;
      maintainers = with maintainers; [
        onny
        ck3d
      ];
      platforms = platforms.linux;
    };
  };
in
self
