{
  config,
  lib,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,

  autoPatchelfHook,
  cargo-tauri,
  cudaPackages,
  pkg-config,
  pnpm,
  wrapGAppsHook3,

  alsa-lib,
  atk,
  cacert,
  glib,
  libayatana-appindicator,
  nodejs,
  onnxruntime,
  openssl,
  webkitgtk_4_1,

  cudaSupport ? config.cudaSupport,
  debugBuild ? false,
}:

rustPlatform.buildRustPackage (final: {
  pname = "airi";
  version = "0.7.0-alpha.1";

  src = fetchFromGitHub {
    owner = "moeru-ai";
    repo = "airi";
    rev = "v${final.version}"; # TODO: update to 0.7.0
    hash = "sha256-QWpHQ0sVRWZrST//OymoPgs5ls4FiLvFLaktzZZDjto=";
  };

  cargoHash = "sha256-4NzMs3livelYmYBNUAWNrtEvcsuP0+9+mx49hsP+ym0=";

  pnpmDeps = pnpm.fetchDeps {
    inherit (final) pname version src;
    fetcherVersion = 1;
    hash = "sha256-ZtIR3vkxxBdIiKgZQrmvlO66OK/NkIM2o6NUvv1vuFs=";
  };

  # Cache of assets downloaded during vite build
  assets = stdenvNoCC.mkDerivation {
    pname = "${final.pname}-assets";
    inherit (final) version src pnpmDeps;

    nativeBuildInputs = [
      cacert # For network request
      nodejs
      pnpm.configHook
    ];

    buildPhase = ''
      runHook preBuild

      pnpm run build:packages
      pnpm -F @proj-airi/stage-tamagotchi run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r apps/stage-tamagotchi/.cache/assets $out

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-QDGx5sWlWwgMWvG/umkNY+Ct9i5zl+eKEJnvA2whPkY=";
  };

  nativeBuildInputs =
    [
      autoPatchelfHook
      cargo-tauri.hook
      nodejs
      pkg-config
      pnpm.configHook
      wrapGAppsHook3
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc # Used by cudarc and bindgen_cuda
    ];

  buildInputs =
    [
      alsa-lib # Used by alsa-sys
      atk # Used by atk-sys
      glib # Used by glib-sys
      libayatana-appindicator # Used by libappindicator-sys
      onnxruntime # Used by ort-sys
      openssl # Used by openssl-sys
      webkitgtk_4_1
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cccl # For nv/target used by bindgen_cuda
      cudaPackages.cuda_cudart # For cuda.h used by cudarc
      cudaPackages.cuda_nvrtc
      cudaPackages.libcublas
      cudaPackages.libcurand
    ];

  env = lib.optionalAttrs cudaSupport {
    # For bindgen_cuda
    CUDA_COMPUTE_CAP = builtins.replaceStrings [ "." ] [ "" ] (
      builtins.head cudaPackages.flags.cudaCapabilities
    );
  };

  configurePhase = ''
    runHook preConfigure

    echo Setting up asset cache
    mkdir apps/stage-tamagotchi/.cache
    cp -r $assets/assets apps/stage-tamagotchi/.cache

    ${lib.optionalString cudaSupport ''
      echo Patching cudarc build script to find CUDA
      # In configurePhase because CUDA is set up in a pre configure hook
      # cudarc searches in a few environment variables, but they can't be used because they don't
      # support the CUDAToolkit_ROOT format (semicolon-separated list of paths).
      # https://github.com/coreylowman/cudarc/blob/main/build.rs#L211
      substituteInPlace ../cargo-vendor-dir/cudarc-*/build.rs \
        --replace-fail /usr/lib/cuda "$(echo "$CUDAToolkit_ROOT" | sed 's/;/", "/g')"

      echo Patching bindgen_cuda to find CUDA # Used by candle-kernels
      # bindgen_cuda copies the pathfinding logic from cudarc
      # https://github.com/Narsil/bindgen_cuda/blob/main/src/lib.rs#L436
      substituteInPlace ../cargo-vendor-dir/bindgen_cuda-*/src/lib.rs \
        --replace-fail /usr/lib/cuda "$(echo "$CUDAToolkit_ROOT" | sed 's/;/", "/g')"
    ''}

    runHook postConfigure
  '';

  preBuild = ''
    pnpm run build:packages
  '';

  buildAndTestSubdir = "apps/stage-tamagotchi";
  buildType = if debugBuild then "debug" else "release";
  cargoBuildFeatures = lib.optional cudaSupport "cuda";

  postInstall = ''
    mv $out/bin/app $out/bin/airi
  '';

  # Add missing runtime dependency
  preFixup = ''
    patchelf --add-needed libayatana-appindicator3.so.1 $out/bin/airi
  '';

  meta = {
    description = "Self-hostable AI waifu / companion / VTuber";
    longDescription = ''
      AIRI is a container of souls of AI waifu / virtual characters to bring them into our worlds,
      wishing to achieve Neuro-sama's altitude, completely LLM and AI driven, capable of realtime
      voice chat, Minecraft playing, Factorio playing. It can be run in Browser or Desktop.
    '';
    homepage = "https://github.com/moeru-ai/airi";
    changelog = "https://github.com/moeru-ai/airi/releases/tag/v${final.version}";
    # While airi itself is licensed under MIT, it uses the nonfree Cubism SDK. Whether it's
    # redistributable remains a question, so we say it's not.
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "airi";
    maintainers = with lib.maintainers; [ weathercold ];
  };
})
