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
  mesh-llm-native-runtime,
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
    mesh-llm-native-runtime.override (
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
  inherit (mesh-llm-native-runtime) version;
  src = mesh-llm-native-runtime.meshLlmSrc;

  cargoHash = "sha256-BMLcQnYgOSshqp+y16zomAUdsGX4bAPrv4iYYx96T3g=";
  cargoBuildFlags = [
    "--package"
    "mesh-llm"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  # The web console, embedded into the binary by the default web-ui feature.
  pnpmRoot = "crates/mesh-llm-ui";
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

  # For CLI tests that build an HTTPS client or run the QA harnesses in scripts/.
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

    # Use nixpkgs' protoc instead of the prebuilt one from protoc-bin-vendored.
    substituteInPlace crates/{mesh-llm-plugin,skippy-protocol}/build.rs \
      --replace-fail 'protoc_bin_vendored::protoc_bin_path().expect("vendored protoc")' \
        'std::path::PathBuf::from(std::env::var("PROTOC").expect("PROTOC"))'
  '';

  env = {
    # aws-lc-sys: its CMake builder, as nixpkgs' default crate overrides use.
    AWS_LC_SYS_CMAKE_BUILDER = 1;
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
          lib.mapAttrsToList (name: value: [
            "--set-default"
            name
            value
          ]) runtimeEnvironment
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

  passthru = {
    # The bundles, their environment and the programs mesh-llm runs, for programs
    # that embed mesh-llm (buzz-desktop).
    inherit runtimes runtimeEnvironment runtimePrograms;
    # Also updates mesh-llm-native-runtime, which pins the release.
    updateScript = ./update.sh;
    tests = {
      nixos = nixosTests.mesh-llm;
      # Upstream's package QA (Mesh-LLM/mesh-packaging): a client reaches
      # readiness offline and stops cleanly on SIGINT.
      client-ready =
        runCommand "mesh-llm-client-ready"
          {
            # The client builds an HTTPS client at startup, which loads the CA bundle.
            nativeBuildInputs = [
              finalAttrs.finalPackage
              cacert
            ];
            # In the macOS build sandbox mesh-llm crashes at startup; without the
            # sandbox the check passes there too.
            meta.platforms = lib.platforms.linux;
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
    changelog = "https://github.com/Mesh-LLM/mesh-llm/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "mesh-llm";
    inherit (mesh-llm-native-runtime.meta) platforms;
  };
})
