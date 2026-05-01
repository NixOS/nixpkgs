{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  gitMinimal,
  meson,
  ninja,
  pkg-config,
  python3Packages,

  # buildInputs
  abseil-cpp,
  asio,
  aws-sdk-cpp,
  hwloc,
  libaio,
  libfabric,
  liburing,
  numactl,
  taskflow,
  ucx,

  # passthru
  nix-update-script,

  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
}:
let
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "nixl";
  version = "1.0.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ai-dynamo";
    repo = "nixl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mDpDqwUwI0baIDDpt9/wgIP3saBWY8yWKgwzHgrzJiU=";
  };

  postPatch =
    # Fix deprecated abseil-cpp Mutex API (Lock/Unlock/ReaderLock/ReaderUnlock
    # replaced by lock/unlock/lock_shared/unlock_shared in abseil 20260107)
    ''
      substituteInPlace src/core/sync.h \
        --replace-fail 'm.Lock()' 'm.lock()' \
        --replace-fail 'm.Unlock()' 'm.unlock()' \
        --replace-fail 'm.ReaderLock()' 'm.lock_shared()' \
        --replace-fail 'm.ReaderUnlock()' 'm.unlock_shared()'
    ''
    # Fix asio::io_context::post() removed in asio 1.36+
    # Use the free function asio::post(io_context, handler) instead
    + ''
      substituteInPlace src/plugins/ucx/ucx_backend.cpp \
        --replace-fail 'io_->post(' 'asio::post(*io_, '
    ''
    # Fix UB: explicit destructor call on lock_guard (GCC 15 -Werror=maybe-uninitialized)
    # Replace lock_guard + manual destructor with unique_lock + unlock()
    + ''
      substituteInPlace src/plugins/libfabric/libfabric_backend.cpp \
        --replace-fail \
          'std::lock_guard<std::mutex> lock(connection_state_mutex_);' \
          'std::unique_lock<std::mutex> lock(connection_state_mutex_);' \
        --replace-fail \
          'lock.~lock_guard();' \
          'lock.unlock();'
    ''
    # Fix GDS plugin: Nix uses lib/ not lib64/
    + ''
      substituteInPlace src/plugins/cuda_gds/meson.build src/plugins/gds_mt/meson.build \
        --replace-fail "'/lib64'" "'/lib'"
    '';

  nativeBuildInputs = [
    cmake
    gitMinimal
    meson
    ninja
    pkg-config
    python3Packages.python
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    abseil-cpp
    asio
    aws-sdk-cpp
    hwloc
    libaio
    libfabric
    liburing
    numactl
    taskflow
    ucx

    python3Packages.python
    # Using C++ header files, not Python import
    python3Packages.pybind11
  ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart
      cuda_nvcc # crt/host_config.h; even though we include this in nativeBuildInputs, it's needed here too
      libcufile # cufile.h
    ]
    # libcuobjclient is only available on cuda>=13.1
    ++ lib.optionals (libcuobjclient.meta.available or false) [
      libcuobjclient
    ]
  );

  mesonFlags = [
    (lib.mesonOption "cudapath_lib" "${lib.getLib cudaPackages.cuda_cudart}/lib")
    (lib.mesonOption "gds_path" (lib.getInclude cudaPackages.cuda_cudart).outPath)

    # Override C++17 -> C++20: taskflow 4.0 headers require C++20 features
    # (std::bit_ceil, std::atomic::wait/notify, std::atomic_flag::test, etc.)
    (lib.mesonOption "cpp_std" "c++20")

    # Disable -Werror to prevent false positives from stricter GCC 15 -Wmaybe-uninitialized
    (lib.mesonOption "werror" "false")
  ];

  passthru = {
    updateScript = nix-update-script { };

    # propagate the stdenv so that the python API can consume it directly
    stdenv = effectiveStdenv;

    pythonPackage = python3Packages.nixl;
  };

  meta = {
    description = "NVIDIA Inference Xfer Library";
    homepage = "https://github.com/ai-dynamo/nixl";
    changelog = "https://github.com/ai-dynamo/nixl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
    broken = !cudaSupport;
  };
})
