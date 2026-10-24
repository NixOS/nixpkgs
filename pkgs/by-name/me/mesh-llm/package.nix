{
  lib,
  stdenv,
  rustPlatform,
  buildPackages,
  fetchPnpmDeps,
  cacert,
  cmake,
  makeBinaryWrapper,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  pkg-config,
  python3,
  curl,
  versionCheckHook,
  skippy-native-runtime,
  rocmPackages,
  nixosTests,
  runCommand,

  config,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}:

let
  # The llama.cpp runtime bundles mesh-llm picks from, built here so nothing is downloaded.
  runtime =
    args:
    skippy-native-runtime.override (
      {
        cudaSupport = false;
        rocmSupport = false;
      }
      // args
    );
  runtimes = [
    (runtime { })
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ (runtime { vulkanSupport = true; }) ]
  ++ lib.optionals cudaSupport [ (runtime { cudaSupport = true; }) ]
  ++ lib.optionals rocmSupport [ (runtime { rocmSupport = true; }) ];

  # Where mesh-llm finds the bundles, and what they need it to know.
  runtimeEnvironment = lib.mergeAttrsList (map (r: r.hostEnvironment) runtimes) // {
    MESH_LLM_NATIVE_RUNTIME_BUNDLE_DIR = lib.makeSearchPath "share/mesh-llm/runtimes" runtimes;
  };

  # Programs mesh-llm runs to detect GPUs: rocm-smi reports the AMD GPUs and their VRAM.
  # nvidia-smi comes with the NVIDIA driver instead.
  runtimePrograms = lib.optionals rocmSupport [ rocmPackages.rocm-smi ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm";

  __structuredAttrs = true;
  strictDeps = true;
  # The runtime is built from the same MeshLLM release.
  inherit (skippy-native-runtime) version;
  src = skippy-native-runtime.meshLlmSrc;

  inherit (skippy-native-runtime) cargoHash;
  cargoBuildFlags = [
    "--package"
    "mesh-llm"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  # The web console, embedded into the binary by the default web-ui feature.
  pnpmRoot = "mesh/crates/mesh-llm-ui";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pnpmRoot}";
    # The console's package.json pins pnpm 10 (`packageManager`).
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-ZnBIXTOaG++AE6br+ZQqtDo1FSgUrzbti5Z5O/fh7D0=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    nodejs
    pnpm_10
    pnpmConfigHook
    pkg-config
  ];

  # Some tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;

  # curl and python3 run the QA harnesses in scripts/. The CLI tests build an
  # HTTPS client for localhost, which fails without a CA bundle; fixed upstream
  # by https://github.com/Mesh-LLM/mesh-llm/pull/2492, drop cacert with a
  # release that has it.
  nativeCheckInputs = [
    cacert
    curl
    python3
  ];

  preCheck = ''
    patchShebangs scripts
  '';

  postPatch = ''
    # Upstream's cargo config routes builds through sccache and its own linker drivers.
    rm .cargo/config.toml
  '';

  env = {
    # aws-lc-sys: its CMake builder, as nixpkgs' default crate overrides use.
    AWS_LC_SYS_CMAKE_BUILDER = 1;
    # nixpkgs' protoc instead of the prebuilt one from protoc-bin-vendored.
    PROTOC = lib.getExe' buildPackages.protobuf "protoc";
  };

  # cmake is only used by dependency build scripts
  dontUseCmakeConfigure = true;

  preBuild = ''
    pnpm --dir ${finalAttrs.pnpmRoot} build
  '';

  postInstall = ''
    wrapProgram $out/bin/mesh-llm ${
      lib.escapeShellArgs (
        lib.concatLists (
          lib.mapAttrsToList
            (name: value: [
              "--set-default"
              name
              value
            ])
            (
              runtimeEnvironment
              // {
                # nixpkgs updates mesh-llm, so it doesn't look for newer releases itself;
                # MESH_LLM_NO_UPDATE_CHECK=0 turns the checks back on.
                MESH_LLM_NO_UPDATE_CHECK = "1";
              }
            )
        )
        ++ lib.optionals (runtimePrograms != [ ]) [
          "--prefix"
          "PATH"
          ":"
          (lib.makeBinPath runtimePrograms)
        ]
      )
    }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  # An unstable version reports only its release.
  preVersionCheck = "version=${lib.head (lib.splitString "-" finalAttrs.version)}";

  passthru = {
    # The bundles, their environment and the programs mesh-llm runs, for programs
    # that embed mesh-llm (buzz-desktop).
    inherit runtimes runtimeEnvironment runtimePrograms;
    # Also updates skippy-native-runtime, which pins the release.
    updateScript = ./update.sh;
    tests = {
      nixos = nixosTests.mesh-llm;
      # Upstream's package QA (Mesh-LLM/mesh-packaging): a client reaches
      # readiness offline and stops cleanly on SIGINT.
      client-ready =
        runCommand "mesh-llm-client-ready"
          {
            # The client builds an HTTPS client at startup, which fails without a
            # CA bundle. Fixed upstream by
            # https://github.com/Mesh-LLM/mesh-llm/pull/2492; drop cacert with a
            # release that has it.
            nativeBuildInputs = [
              finalAttrs.finalPackage
              cacert
            ];
            # The client binds its mesh and console ports on localhost.
            __darwinAllowLocalNetworking = true;
            # On Darwin, iroh's interface detection reaches CoreFoundation APIs that
            # read ICU data from the system and segfault without it, as for dumbpipe.
            sandboxProfile = ''
              (allow file-read* (subpath "/usr/share/icu"))
            '';
          }
          ''
            export HOME=$TMPDIR/home XDG_CACHE_HOME=$TMPDIR/cache XDG_CONFIG_HOME=$TMPDIR/config
            export XDG_STATE_HOME=$TMPDIR/state MESH_LLM_NATIVE_RUNTIME_CACHE_DIR=$TMPDIR/runtimes
            mesh-llm --log-format json --port 19337 --console 13131 --no-console client > client.jsonl 2>&1 &
            pid=$!
            ready() {
              grep -q '"Client ready"' client.jsonl \
                || grep '"event": *"passive_mode"' client.jsonl | grep '"status": *"ready"' | grep -q '"role": *"client"'
            }
            for _ in $(seq 450); do
              ready && break
              kill -0 $pid || { cat client.jsonl; echo "client exited before readiness" >&2; exit 1; }
              sleep 0.1
            done
            ready || { cat client.jsonl; echo "client not ready after 45s" >&2; exit 1; }
            kill -INT $pid
            timeout 30 tail --pid=$pid -f /dev/null || { echo "client did not stop after SIGINT" >&2; exit 1; }
            wait $pid
            touch $out
          '';
    }
    # The GPU runtimes build without a GPU; building them catches packaging breakage
    # in backends that can't run here. One ROCm target is enough for that.
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      runtime-rocm = runtime {
        rocmSupport = true;
        rocmGpuTargets = [ "gfx1100" ];
      };
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isLinux && config.allowUnfree) {
      runtime-cuda = runtime { cudaSupport = true; };
    };
  };

  meta = {
    description = "Pool spare GPU capacity to run LLMs at larger scale";
    longDescription = ''
      MeshLLM pools the GPUs of several machines to serve large language
      models through an OpenAI-compatible API and a web console. This package
      bundles a CPU runtime and, on Linux, a Vulkan runtime. CUDA and ROCm
      runtimes come with `mesh-llm-cuda` (unfree) and `mesh-llm-rocm`, or with
      the nixpkgs settings `cudaSupport` and `rocmSupport`. To run a node on
      NixOS, use `services.mesh-llm`.
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm";
    inherit (skippy-native-runtime.meta) changelog;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "mesh-llm";
    inherit (skippy-native-runtime.meta) platforms;
  };
})
