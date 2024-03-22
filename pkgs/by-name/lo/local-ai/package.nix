{ stdenv
, lib
, fetchpatch
, fetchFromGitHub
, ncurses
, protobuf
, grpc
, openssl
  # needed for audio-to-text
, ffmpeg
, cmake
, buildGoModule
, makeWrapper
, runCommand
, testers

  # apply feature parameter names according to
  # https://github.com/NixOS/rfcs/pull/169

, with_tinydream ? false

, with_openblas ? false
, openblas
, pkg-config

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
  go-llama-ggml = fetchFromGitHub {
    owner = "go-skynet";
    repo = "go-llama.cpp";
    rev = "2b57a8ae43e4699d3dc5d1496a1ccd42922993be";
    hash = "sha256-D6SEg5pPcswGyKAmF4QTJP6/Y1vjRr7m7REguag+too=";
    fetchSubmodules = true;
  };

  # possible improvement: use Nix package llama-cpp
  llama_cpp = fetchFromGitHub {
    owner = "ggerganov";
    repo = "llama.cpp";
    rev = "d01b3c4c32357567f3531d4e6ceffc5d23e87583";
    hash = "sha256-7eaQV+XTCXdrJlo7y21q5j/8ecVwuTMJScRTATcF6oM=";
    fetchSubmodules = true;
  };

  llama_cpp' = runCommand "llama_cpp_src" { } ''
    cp -r --no-preserve=mode,ownership ${llama_cpp} $out
    sed -i $out/CMakeLists.txt \
      -e 's;pkg_check_modules(DepBLAS REQUIRED openblas);pkg_check_modules(DepBLAS REQUIRED openblas64);'
  '';

  gpt4all = fetchFromGitHub {
    owner = "nomic-ai";
    repo = "gpt4all";
    rev = "27a8b020c36b0df8f8b82a252d261cda47cf44b8";
    hash = "sha256-djq1eK6ncvhkO3MNDgasDBUY/7WWcmZt/GJsHAulLdI=";
    fetchSubmodules = true;
  };

  go-piper = fetchFromGitHub {
    owner = "mudler";
    repo = "go-piper";
    rev = "9d0100873a7dbb0824dfea40e8cec70a1b110759";
    hash = "sha256-Yv9LQkWwGpYdOS0FvtP0vZ0tRyBAx27sdmziBR4U4n8=";
    fetchSubmodules = true;
  };

  go-rwkv = fetchFromGitHub {
    owner = "donomii";
    repo = "go-rwkv.cpp";
    rev = "661e7ae26d442f5cfebd2a0881b44e8c55949ec6";
    hash = "sha256-byTNZQSnt7qpBMng3ANJmpISh3GJiz+F15UqfXaz6nQ=";
    fetchSubmodules = true;
  };

  whisper = fetchFromGitHub {
    owner = "ggerganov";
    repo = "whisper.cpp";
    rev = "a56f435fd475afd7edf02bfbf9f8c77f527198c2";
    hash = "sha256-ozTnxEuftAQQr5v/kwg5EKHuKF21d9ETIyvXcvr0Qos=";
    fetchSubmodules = true;
  };

  go-bert = fetchFromGitHub {
    owner = "go-skynet";
    repo = "go-bert.cpp";
    rev = "6abe312cded14042f6b7c3cd8edf082713334a4d";
    hash = "sha256-lh9cvXc032Eq31kysxFOkRd0zPjsCznRl0tzg9P2ygo=";
    fetchSubmodules = true;
  };

  go-stable-diffusion = stdenv.mkDerivation {
    pname = "go_stable_diffusion";
    version = "unstable";
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
      install -Dt $out libstablediffusion.a Makefile go.mod *.go stablediffusion.h
    '';
  };

  go-tiny-dream = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "go-tiny-dream";
    rev = "772a9c0d9aaf768290e63cca3c904fe69faf677a";
    hash = "sha256-r+wzFIjaI6cxAm/eXN3q8LRZZz+lE5EA4lCTk5+ZnIY=";
    fetchSubmodules = true;
  };

  go-tiny-dream' = runCommand "go_tiny_dream_src" { } ''
    cp -r --no-preserve=mode,ownership ${go-tiny-dream} $out
    sed -i $out/Makefile \
      -e 's;lib/libncnn;lib64/libncnn;g'
  '';

  GO_TAGS = lib.optional with_tinydream "tinydream"
    ++ lib.optional with_tts "tts"
    ++ lib.optional with_stablediffusion "stablediffusion";

  buildEnv =
    if with_cublas then
    # It's necessary to consistently use backendStdenv when building with CUDA support,
    # otherwise we get libstdc++ errors downstream.
      buildGoModule.override { stdenv = cudaPackages.backendStdenv; }
    else
      buildGoModule;

  self = buildEnv rec {
    pname = "local-ai";
    version = "2.10.1";

    src = fetchFromGitHub {
      owner = "go-skynet";
      repo = "LocalAI";
      rev = "v${version}";
      hash = "sha256-135s1Gw8mfOIx4kXlw2pYrD3ewwajUtnz3sPY/CtoLw=";
    };

    vendorHash = "sha256-UCeG0TKS+VBW8D87VmxTHS2tCAf0ADEYTJayaSiua6s=";

    # Workaround for
    # `cc1plus: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]`
    # when building jtreg
    env.NIX_CFLAGS_COMPILE = "-Wformat";

    postPatch =
      let
        cp = "cp -r --no-preserve=mode,ownership";
      in
      ''
        sed -i Makefile \
          -e 's;git clone.*go-llama-ggml$;${cp} ${go-llama-ggml} sources/go-llama-ggml;' \
          -e 's;git clone.*gpt4all$;${cp} ${gpt4all} sources/gpt4all;' \
          -e 's;git clone.*go-piper$;${cp} ${go-piper} sources/go-piper;' \
          -e 's;git clone.*go-rwkv$;${cp} ${go-rwkv} sources/go-rwkv;' \
          -e 's;git clone.*whisper\.cpp$;${cp} ${whisper} sources/whisper\.cpp;' \
          -e 's;git clone.*go-bert$;${cp} ${go-bert} sources/go-bert;' \
          -e 's;git clone.*diffusion$;${cp} ${if with_stablediffusion then go-stable-diffusion else go-stable-diffusion.src} sources/go-stable-diffusion;' \
          -e 's;git clone.*go-tiny-dream$;${cp} ${go-tiny-dream'} sources/go-tiny-dream;' \
          -e 's, && git checkout.*,,g' \
          -e '/mod download/ d' \

        sed -i backend/cpp/llama/Makefile \
          -e 's;git clone.*llama\.cpp$;${cp} ${llama_cpp'} llama\.cpp;' \
          -e 's, && git checkout.*,,g' \

      ''
    ;

    modBuildPhase = ''
      mkdir sources
      make prepare-sources
      go mod tidy -v
    '';

    proxyVendor = true;

    buildPhase =
      let
        buildType =
          assert (lib.count lib.id [ with_openblas with_cublas with_clblas ]) <= 1;
          if with_openblas then "openblas"
          else if with_cublas then "cublas"
          else if with_clblas then "clblas"
          else "";

        buildFlags = [
          "VERSION=v${version}"
          "BUILD_TYPE=${buildType}"
          "GO_TAGS=\"${builtins.concatStringsSep " " GO_TAGS}\""
        ]
        ++ lib.optional with_cublas "CUDA_LIBPATH=${cudaPackages.cuda_cudart}/lib";
      in
      ''
        mkdir sources
        make ${builtins.concatStringsSep " " buildFlags} build
      '';

    installPhase = ''
      install -Dt $out/bin ${pname}
    '';

    buildInputs = [
      protobuf # provides also abseil_cpp as propagated build input
      grpc
      openssl
    ]
    ++ lib.optionals with_stablediffusion
      [ opencv ]
    ++ lib.optionals with_tts
      [ sonic spdlog fmt onnxruntime ]
    ++ lib.optionals with_cublas
      [ cudaPackages.cudatoolkit cudaPackages.cuda_cudart ]
    ++ lib.optionals with_openblas
      [ openblas.dev ]
    ++ lib.optionals with_clblas
      [ clblast ocl-icd opencl-headers ]
    ;

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

    nativeBuildInputs = [
      ncurses
      cmake
      makeWrapper
    ]
    ++ lib.optional with_openblas pkg-config
    ++ lib.optional with_cublas cudaPackages.cuda_nvcc
    ;

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
      broken =
        # TODO: provide onnxruntime in the right way
        with_tts
        || (with_tinydream && (lib.lessThan self.stdenv.cc.version "13"));
    };
  };
in
self
