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
  makeBinaryWrapper,
  ncurses,
  which,
  opencv,
  curl,
  git,
  fetchNpmDeps,
  npmHooks,
  nodejs,

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
      postPatch = "";
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
          rev = "221f0f6356efe2260023208365705ec5d5a7c8f5";
          hash = "sha256-MxSoUmCdusWpiXO8/ZvCV2yRGE7JUAm4/rkyPkuxcnY=";
          fetchSubmodules = true;
        };
        npmDeps = null;
        npmConfigHook = null;
        preConfigure = "";
        postConfigure = "";
        # Mirror LocalAI backend/cpp/llama-cpp/prepare.sh against this llama.cpp pin.
        postPatch = ''
          llamaCppBackend=${src}/backend/cpp/llama-cpp
          if [ -d "$llamaCppBackend/patches" ]; then
            for patch in "$llamaCppBackend"/patches/*; do
              echo "Applying LocalAI llama.cpp patch $patch"
              patch -p1 < "$patch"
            done
          fi

          mkdir -p tools/grpc-server
          for f in tools/server/*; do
            cp -r --no-preserve=mode "$f" tools/grpc-server/
          done
          cp --no-preserve=mode \
            "$llamaCppBackend"/CMakeLists.txt \
            "$llamaCppBackend"/grpc-server.cpp \
            "$llamaCppBackend"/message_content.h \
            "$llamaCppBackend"/message_content_test.cpp \
            "$llamaCppBackend"/passthrough_options.h \
            "$llamaCppBackend"/passthrough_options_test.cpp \
            "$llamaCppBackend"/parent_watch.h \
            "$llamaCppBackend"/parent_watch_test.cpp \
            tools/grpc-server/
          cp --no-preserve=mode vendor/nlohmann/json.hpp tools/grpc-server/
          cp --no-preserve=mode vendor/cpp-httplib/httplib.h tools/grpc-server/
          cp --no-preserve=mode ${src}/backend/backend.proto tools/grpc-server/

          if grep -q "LLAMA_LOAD_MODE_MMAP" include/llama.h; then
            legacyLoadMode=0
          else
            legacyLoadMode=1
          fi
          printf '%s\n' \
            '// Generated for LocalAI nix packaging. Do not edit.' \
            '#pragma once' \
            "#define LOCALAI_LEGACY_LOAD_MODE $legacyLoadMode" \
            > tools/grpc-server/llama_compat.h

          sed -i tools/grpc-server/CMakeLists.txt \
            -e '/get_filename_component/ s;[.\/]*backend/;;' \
            -e 's;PRIVATE ../llava;PRIVATE ../mtmd;' \
            -e '$a\install(TARGETS ''${TARGET} RUNTIME)'

          if ! grep -q "grpc-server" tools/CMakeLists.txt; then
            echo "add_subdirectory(grpc-server)" >> tools/CMakeLists.txt
          fi
        '';
        cmakeFlags = prev.cmakeFlags ++ [
          (lib.cmakeBool "BUILD_SHARED_LIBS" false)
          (lib.cmakeBool "GGML_BACKEND_DL" false)
          (lib.cmakeBool "GGML_CPU_ALL_VARIANTS" false)
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
        nativeBuildInputs =
          lib.filter (x: !(lib.hasPrefix "npm-" (x.name or ""))) (prev.nativeBuildInputs or [ ])
          ++ [ git ];
        postInstall = ''
          if [ -e $out/bin/llama-cli ]; then
            ln -sf $out/bin/llama-cli $out/bin/llama
          fi
          mkdir -p $out/include
          cp $src/include/llama.h $out/include/
          if [ -e bin/rpc-server ]; then
            cp bin/rpc-server $out/bin/llama-rpc-server
          elif [ -e bin/ggml-rpc-server ]; then
            cp bin/ggml-rpc-server $out/bin/llama-rpc-server
          elif [ -e $out/bin/ggml-rpc-server ]; then
            ln -sf ggml-rpc-server $out/bin/llama-rpc-server
          fi
        '';
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

  piper-tts' = stdenv.mkDerivation {
    name = "piper-tts'";
    inherit (go-piper) src;
    sourceRoot = "${go-piper.src.name}/piper";
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    buildInputs = [
      espeak-ng'
      piper-phonemize
      fmt
      spdlog
      onnxruntime
    ];
    cmakeFlags = [
      (lib.cmakeFeature "FMT_DIR" "${fmt}")
      (lib.cmakeFeature "SPDLOG_DIR" "${spdlog}")
      (lib.cmakeFeature "PIPER_PHONEMIZE_DIR" "${piper-phonemize}")
    ];
    postInstall = ''
      if [ -f CMakeFiles/piper.dir/src/cpp/piper.cpp.o ]; then
        cp CMakeFiles/piper.dir/src/cpp/piper.cpp.o $out/piper.o
      elif [ -f build/CMakeFiles/piper.dir/src/cpp/piper.cpp.o ]; then
        cp build/CMakeFiles/piper.dir/src/cpp/piper.cpp.o $out/piper.o
      else
        echo "piper.cpp.o not found in expected build directories" >&2
        exit 1
      fi
      cd $out
      mkdir -p bin lib
      if ls lib*so* >/dev/null 2>&1; then
        mv lib*so* lib/
      fi
      if [ -e piper ]; then
        mv piper bin/piper_phonemize
      fi
      rm -rf cmake pkgconfig espeak-ng-data *.ort
    '';
  };

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
      owner = "ggml-org";
      repo = "whisper.cpp";
      rev = "306c88f4d1286aec1bf96e544632897886af5501";
      hash = "sha256-tW3UkERd/4PLpjSObBkZVqJPzue70oGeLDNiQDTDwSU=";
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
      (lib.cmakeBool "GGML_CUDA" with_cublas)
      (lib.cmakeBool "GGML_BLAS" with_openblas)
      (lib.cmakeBool "GGML_AVX" enable_avx)
      (lib.cmakeBool "GGML_AVX2" enable_avx2)
      (lib.cmakeBool "GGML_FMA" enable_fma)
      (lib.cmakeBool "GGML_F16C" enable_f16c)
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
    cmakeFlags = [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];
    nativeBuildInputs = [ cmake ];
  };

  stable-diffusion = stdenv.mkDerivation {
    name = "stable-diffusion";
    src = fetchFromGitHub {
      owner = "leejet";
      repo = "stable-diffusion.cpp";
      rev = "ea7f0c87cfe4c673263b4c201c596c7f1cbe2528";
      hash = "sha256-6SbkmYj7h+uCz4oUChr6nh/N3Xvu6E/Yyf2sb6NZn5c=";
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
  version = "4.8.2";
  src = fetchFromGitHub {
    owner = "mudler";
    repo = "LocalAI";
    tag = "v${version}";
    hash = "sha256-xdqefohG5lW63Ia4c0FcpdQ57vpTeLiXz7cNoyU4hXw=";
  };

  prepare-sources =
    let
      cp = "cp -r --no-preserve=mode,ownership";
    in
    ''
      mkdir sources
      ${cp} ${if with_tts then go-piper else go-piper.src} sources/go-piper
      ${cp} ${whisper-cpp.src} sources/whisper.cpp
      if ls ${whisper-cpp}/lib/lib*.a >/dev/null 2>&1; then
        cp ${whisper-cpp}/lib/lib*.a sources/whisper.cpp
      fi
      ${cp} ${bark} sources/bark.cpp
      ${cp} ${stable-diffusion} sources/stablediffusion-ggml.cpp
    '';

  frontend = stdenv.mkDerivation {
    pname = "${pname}-frontend";
    inherit version src;

    sourceRoot = "${src.name}/core/http/react-ui";

    npmDeps = fetchNpmDeps {
      src = "${src}/core/http/react-ui";
      hash = "sha256-CWG9xlnukGI/9KqyCOslTJtYJ7TireRH4TWI01WVzRo=";
    };

    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
    ];

    buildPhase = ''
      runHook preBuild
      npm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

  self = buildGoModule.override { stdenv = effectiveStdenv; } {
    inherit pname version src;

    vendorHash = "sha256-cCf6C6MgEZyexnr1hYH7CcBHT25cozqMIYEnna1+J/Y=";

    env.NIX_CFLAGS_COMPILE = " -isystem ${opencv}/include/opencv4";

    postPatch = ''
      # TODO: add silero-vad
      sed -i Makefile \
        -e '/mod download/ d' \
        -e '/^ALL_GRPC_BACKENDS+=backend-assets\/grpc\/llama-cpp-avx/ d' \
        -e '/^ALL_GRPC_BACKENDS+=backend-assets\/grpc\/llama-cpp-cuda/ d' \
        -e '/^ALL_GRPC_BACKENDS+=backend-assets\/grpc\/silero-vad/ d' \

      if [ -f backend/go/image/stablediffusion-ggml/Makefile ]; then
        sed -i backend/go/image/stablediffusion-ggml/Makefile \
          -e '/^libsd/ s,$, $(COMBINED_LIB),'
      fi
      if [ -f backend/go/stablediffusion-ggml/Makefile ]; then
        sed -i backend/go/stablediffusion-ggml/Makefile \
          -e '/^libsd/ s,$, $(COMBINED_LIB),'
      fi

    ''
    + lib.optionalString with_cublas ''
      sed -i Makefile \
        -e '/^CGO_LDFLAGS_WHISPER?=/ s;$;-L${libcufft}/lib -L${cuda_cudart}/lib;'
    '';

    postConfigure = prepare-sources + ''
      shopt -s extglob
      mkdir -p backend-assets/grpc
      cp ${llama-cpp-grpc}/bin/grpc-server backend-assets/grpc/llama-cpp-fallback
      cp ${llama-cpp-grpc}/bin/grpc-server backend-assets/grpc/llama-cpp-grpc

      mkdir -p backend/cpp/llama-cpp/llama.cpp

      mkdir -p backend-assets/util
      cp ${llama-cpp-rpc}/bin/llama-rpc-server backend-assets/util/llama-cpp-rpc-server

      if [ -d backend/go/image/stablediffusion-ggml ] || [ -d backend/go/stablediffusion-ggml ]; then
        sd_dir=backend/go/image/stablediffusion-ggml
        if [ ! -d "$sd_dir" ]; then
          sd_dir=backend/go/stablediffusion-ggml
        fi
        mkdir -p "$sd_dir"
        cp -r --no-preserve=mode,ownership ${stable-diffusion}/build "$sd_dir/build"
      fi

      # Inject pre-built React UI
      mkdir -p core/http/react-ui/dist
      cp -r --no-preserve=mode,ownership ${frontend}/* core/http/react-ui/dist/

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
      makeBinaryWrapper
      ncurses # tput
      which
    ]
    ++ lib.optional enable_upx upx
    ++ lib.optionals with_cublas [ cuda_nvcc ];

    enableParallelBuilding = false;

    modBuildPhase = prepare-sources + ''
      mkdir -p pkg/grpc/proto
      protoc \
        --experimental_allow_proto3_optional \
        -Ibackend/ \
        --go_out=pkg/grpc/proto/ \
        --go_opt=paths=source_relative \
        --go-grpc_out=pkg/grpc/proto/ \
        --go-grpc_opt=paths=source_relative \
        backend/backend.proto
      go mod tidy -v
    '';

    proxyVendor = true;

    # should be passed as makeFlags, but build system fails with strings
    # containing spaces
    env.GO_TAGS = builtins.concatStringsSep " " GO_TAGS;
    env.LD_FLAGS = "-s -w -X github.com/mudler/LocalAI/internal.Version=v${version} -X github.com/mudler/LocalAI/internal.Commit=unknown";

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
      concatTo flagsArray makeFlags makeFlagsArray buildFlags buildFlagsArray

      if [ -f backend/go/image/stablediffusion-ggml/Makefile ]; then
        # copy from Makefile:258
        make -C backend/go/image/stablediffusion-ggml libsd.a "''${flagsArray[@]}"
      fi

      mkdir -p pkg/grpc/proto
      protoc \
        --experimental_allow_proto3_optional \
        -Ibackend/ \
        --go_out=pkg/grpc/proto/ \
        --go_opt=paths=source_relative \
        --go-grpc_out=pkg/grpc/proto/ \
        --go-grpc_opt=paths=source_relative \
        backend/backend.proto

      CGO_LDFLAGS="$CGO_LDFLAGS" \
        go build -ldflags "$LD_FLAGS" -tags "$GO_TAGS" -o ${pname} ./cmd/local-ai

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dt $out/bin ${pname}

      runHook postInstall
    '';

    # patching rpath with patchelf doesn't work. The executable
    # raises a segmentation fault
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
        --prefix PATH : "${ffmpeg}/bin" \
        --set PCIDB_ENABLE_NETWORK_FETCH "1"
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

    meta = {
      description = "OpenAI alternative to run local LLMs, image and audio generation";
      mainProgram = "local-ai";
      homepage = "https://localai.io";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        onny
        ck3d
      ];
      platforms = lib.platforms.linux;
    };
  };
in
self
