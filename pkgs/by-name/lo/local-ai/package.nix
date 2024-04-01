{ stdenv
, lib
, fetchpatch
, fetchFromGitHub
, protobuf
, grpc
, openssl
, llama-cpp
  # needed for audio-to-text
, ffmpeg
, cmake
, pkg-config
, buildGoModule
, makeWrapper
, runCommand
, testers

  # apply feature parameter names according to
  # https://github.com/NixOS/rfcs/pull/169

  # CPU extensions
, enable_avx ? true
, enable_avx2 ? true
, enable_avx512 ? false
, enable_f16c ? true
, enable_fma ? true

, with_tinydream ? false
, ncnn

, with_openblas ? false
, openblas

, with_cublas ? false
, cudaPackages

, with_clblas ? false
, clblast
, ocl-icd
, opencl-headers

, with_stablediffusion ? false
, opencv

, with_tts ? false
, onnxruntime
, sonic
, spdlog
, fmt
}:
let
  BUILD_TYPE =
    assert (lib.count lib.id [ with_openblas with_cublas with_clblas ]) <= 1;
    if with_openblas then "openblas"
    else if with_cublas then "cublas"
    else if with_clblas then "clblas"
    else "";

  typedBuiltInputs =
    lib.optionals with_cublas
      [ cudaPackages.cudatoolkit cudaPackages.cuda_cudart ]
    ++ lib.optionals with_clblas
      [ clblast ocl-icd opencl-headers ]
    ++ lib.optionals with_openblas
      [ openblas.dev ];

  go-llama-ggml = effectiveStdenv.mkDerivation {
    name = "go-llama-ggml";
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
    buildInputs = typedBuiltInputs;
    dontUseCmakeConfigure = true;
    nativeBuildInputs = [ cmake ];
    installPhase = ''
      mkdir $out
      tar cf - --exclude=build --exclude=CMakeFiles --exclude="*.o" . \
        | tar xf - -C $out
    '';
  };

  llama-cpp-grpc = (llama-cpp.overrideAttrs (final: prev: {
    name = "llama-cpp-grpc";
    src = fetchFromGitHub {
      owner = "ggerganov";
      repo = "llama.cpp";
      rev = "d01b3c4c32357567f3531d4e6ceffc5d23e87583";
      hash = "sha256-7eaQV+XTCXdrJlo7y21q5j/8ecVwuTMJScRTATcF6oM=";
      fetchSubmodules = true;
    };
    postPatch = prev.postPatch + ''
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
      (lib.cmakeBool "LLAMA_AVX" enable_avx)
      (lib.cmakeBool "LLAMA_AVX2" enable_avx2)
      (lib.cmakeBool "LLAMA_AVX512" enable_avx512)
      (lib.cmakeBool "LLAMA_FMA" enable_fma)
      (lib.cmakeBool "LLAMA_F16C" enable_f16c)
    ];
    buildInputs = prev.buildInputs ++ [
      protobuf # provides also abseil_cpp as propagated build input
      grpc
      openssl
    ];
  })).override {
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

  go-piper = stdenv.mkDerivation {
    name = "go-piper";
    src = fetchFromGitHub {
      owner = "mudler";
      repo = "go-piper";
      rev = "9d0100873a7dbb0824dfea40e8cec70a1b110759";
      hash = "sha256-Yv9LQkWwGpYdOS0FvtP0vZ0tRyBAx27sdmziBR4U4n8=";
      fetchSubmodules = true;
    };
    patchPhase = ''
      sed -i Makefile \
        -e '/cd piper-phonemize/ s;cmake;cmake -DONNXRUNTIME_DIR=${onnxruntime.dev};' \
        -e '/CXXFLAGS *= / s;$; -DSPDLOG_FMT_EXTERNAL=1;' \
        -e '/cd piper\/build / s;cmake;cmake -DSPDLOG_DIR=${spdlog.src} -DFMT_DIR=${fmt};'
    '';
    buildFlags = [ "libpiper_binding.a" ];
    dontUseCmakeConfigure = true;
    nativeBuildInputs = [ cmake ];
    buildInputs = [ sonic spdlog onnxruntime ];
    installPhase = ''
      cp -r --no-preserve=mode $src $out
      tar cf - *.a \
        espeak/ei/lib \
        piper/src/cpp \
        piper-phonemize/pi/lib \
        piper-phonemize/pi/include \
        piper-phonemize/pi/share \
        | tar xf - -C $out
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
      rev = "a56f435fd475afd7edf02bfbf9f8c77f527198c2";
      hash = "sha256-g8ZhVB5sxpfrFzg/0seSrv0vFG0YOP56253n6/KWHfE=";
    };
    nativeBuildInputs = [ cmake pkg-config ];
    buildInputs = typedBuiltInputs;
    cmakeFlags = [
      (lib.cmakeBool "WHISPER_CUBLAS" with_cublas)
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
      rev = "6abe312cded14042f6b7c3cd8edf082713334a4d";
      hash = "sha256-lh9cvXc032Eq31kysxFOkRd0zPjsCznRl0tzg9P2ygo=";
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
      rev = "362df9da29f882dbf09ade61972d16a1f53c3485";
      hash = "sha256-A5KvMZOviPsIpPHxM8cacT+qE2x1iFJAbPsRs4sLijY=";
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
    sourceRoot = "source/ncnn";
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

  go-tiny-dream = stdenv.mkDerivation {
    name = "go-tiny-dream";
    src = fetchFromGitHub {
      owner = "M0Rf30";
      repo = "go-tiny-dream";
      rev = "772a9c0d9aaf768290e63cca3c904fe69faf677a";
      hash = "sha256-r+wzFIjaI6cxAm/eXN3q8LRZZz+lE5EA4lCTk5+ZnIY=";
      fetchSubmodules = true;
    };
    postUnpack = ''
      rm -rf source/ncnn
      mkdir -p source/ncnn/build
      cp -r --no-preserve=mode ${go-tiny-dream-ncnn} source/ncnn/build/install
    '';
    buildFlags = [ "libtinydream.a" ];
    installPhase = ''
      mkdir $out
      tar cf - --exclude="*.o" . \
        | tar xf - -C $out
    '';
    meta.broken = lib.versionOlder go-tiny-dream.stdenv.cc.version "13";
  };

  GO_TAGS = lib.optional with_tinydream "tinydream"
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
  version = "2.10.1";
  src = fetchFromGitHub {
    owner = "go-skynet";
    repo = "LocalAI";
    rev = "v${version}";
    hash = "sha256-135s1Gw8mfOIx4kXlw2pYrD3ewwajUtnz3sPY/CtoLw=";
  };

  self = buildGoModule.override { stdenv = effectiveStdenv; } {
    inherit pname version src;

    vendorHash = "sha256-UCeG0TKS+VBW8D87VmxTHS2tCAf0ADEYTJayaSiua6s=";

    env.NIX_CFLAGS_COMPILE = lib.optionalString with_stablediffusion " -isystem ${opencv}/include/opencv4";

    postPatch =
      let
        cp = "cp -r --no-preserve=mode,ownership";
      in
      ''
        sed -i Makefile \
          -e 's;git clone.*go-llama-ggml$;${cp} ${go-llama-ggml} sources/go-llama-ggml;' \
          -e 's;git clone.*gpt4all$;${cp} ${gpt4all} sources/gpt4all;' \
          -e 's;git clone.*go-piper$;${cp} ${if with_tts then go-piper else go-piper.src} sources/go-piper;' \
          -e 's;git clone.*go-rwkv$;${cp} ${go-rwkv} sources/go-rwkv;' \
          -e 's;git clone.*whisper\.cpp$;${cp} ${whisper-cpp.src} sources/whisper\.cpp;' \
          -e 's;git clone.*go-bert$;${cp} ${go-bert} sources/go-bert;' \
          -e 's;git clone.*diffusion$;${cp} ${if with_stablediffusion then go-stable-diffusion else go-stable-diffusion.src} sources/go-stable-diffusion;' \
          -e 's;git clone.*go-tiny-dream$;${cp} ${if with_tinydream then go-tiny-dream else go-tiny-dream.src} sources/go-tiny-dream;' \
          -e 's, && git checkout.*,,g' \
          -e '/mod download/ d' \

        ${cp} ${llama-cpp-grpc}/bin/*grpc-server backend/cpp/llama/grpc-server
        echo "grpc-server:" > backend/cpp/llama/Makefile
      ''
    ;

    buildInputs = typedBuiltInputs
      ++ lib.optional with_stablediffusion go-stable-diffusion.buildInputs
      ++ lib.optional with_tts go-piper.buildInputs;

    nativeBuildInputs = [ makeWrapper ];

    enableParallelBuilding = false;

    modBuildPhase = ''
      mkdir sources
      make prepare-sources
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
    ++ lib.optional with_cublas "CUDA_LIBPATH=${cudaPackages.cuda_cudart}/lib"
    ++ lib.optional with_tts "PIPER_CGO_CXXFLAGS=-DSPDLOG_FMT_EXTERNAL=1";

    buildPhase = ''
      runHook preBuild

      mkdir sources
      make prepare-sources
      # avoid rebuild of prebuilt libraries
      touch sources/**/lib*.a
      cp ${whisper-cpp}/lib/static/lib*.a sources/whisper.cpp

      local flagsArray=(
        ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}}
        SHELL=$SHELL
      )
      _accumFlagsArray makeFlags makeFlagsArray buildFlags buildFlagsArray
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
    postFixup = ''
      wrapProgram $out/bin/${pname} \
    '' + lib.optionalString with_cublas ''
      --prefix LD_LIBRARY_PATH : "${cudaPackages.libcublas}/lib:${cudaPackages.cuda_cudart}/lib:/run/opengl-driver/lib" \
    '' + lib.optionalString with_clblas ''
      --prefix LD_LIBRARY_PATH : "${clblast}/lib:${ocl-icd}/lib" \
    '' + lib.optionalString with_openblas ''
      --prefix LD_LIBRARY_PATH : "${openblas}/lib" \
    '' + ''
      --prefix PATH : "${ffmpeg}/bin"
    '';

    passthru.local-packages = {
      inherit
        go-tiny-dream go-rwkv go-bert go-llama-ggml gpt4all go-piper
        llama-cpp-grpc whisper-cpp go-tiny-dream-ncnn;
    };

    passthru.features = {
      inherit
        with_cublas with_openblas with_tts with_stablediffusion
        with_tinydream with_clblas;
    };

    passthru.tests = {
      version = testers.testVersion {
        package = self;
        version = "v" + version;
      };
      health =
        let
          port = "8080";
        in
        testers.runNixOSTest {
          name = pname + "-health";
          nodes.machine = {
            systemd.services.local-ai = {
              wantedBy = [ "multi-user.target" ];
              serviceConfig.ExecStart = "${self}/bin/local-ai --localai-config-dir . --address :${port}";
            };
          };
          testScript = ''
            machine.wait_for_open_port(${port})
            machine.succeed("curl -f http://localhost:${port}/readyz")
          '';
        };
    };

    meta = with lib; {
      description = "OpenAI alternative to run local LLMs, image and audio generation";
      homepage = "https://localai.io";
      license = licenses.mit;
      maintainers = with maintainers; [ onny ck3d ];
      platforms = platforms.linux;
    };
  };
in
self
