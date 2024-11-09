{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  autoPatchelfHook,
  nix-update-script,
  rustPlatform,
  cmake,
  cpm-cmake,
  fontconfig,
  llvmPackages,
  libXau,
  libXdmcp,
  libGL,
  libxkbcommon,
  libclang,
  mesa,
  openxr-loader,
  pkg-config,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-server";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "server";
    rev = "refs/tags/${version}";
    hash = "sha256-SBAt6CyOt28elXGybAx7glLDEs8vYkoaTXHoEaPEuKk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-FNsjbcdiI46nNSWMd4smn5Lg53UU4NFmCfV8ZfaJLs0=";
      "stardust-xr-0.45.0" = "sha256-FdbtBgvknjGW2MnrS2QMwtTSrRjd+KezC3kY5JqRH2s=";
      "stereokit-macros-0.1.0" = "sha256-cs/fbbqMSaoJZIjDEcqjoqlhldtVTRPBczJ4GD8+Sks=";
    };
  };

  # CPM sucks soo much
  buildFeatures = [ "local_deps" ];
  env = {
    FORCE_LOCAL_DEPS = true;
    CPM_LOCAL_PACKAGES_ONLY = true;
    CPM_SOURCE_CACHE = "./build";
    CPM_USE_LOCAL_PACKAGES = true;
    CPM_DOWNLOAD_ALL = false;

    DEP_MESHOPTIMIZER_SOURCE = fetchFromGitHub {
      name = "meshoptimizer-source";
      owner = "zeux";
      repo = "meshoptimizer";
      rev = "c21d3be6ddf627f8ca852ba4b6db9903b0557858";
      hash = "sha256-QCxpM2g8WtYSZHkBzLTJNQ/oHb5j/n9rjaVmZJcCZIA=";
    };
    DEP_BASIS_UNIVERSAL_SOURCE = fetchFromGitHub {
      name = "basis_universal-source";
      owner = "BinomialLLC";
      repo = "basis_universal";
      rev = "900e40fb5d2502927360fe2f31762bdbb624455f";
      hash = "sha256-zBRAXgG5Fi6+5uPQCI/RCGatY6O4ELuYBoKrPNn4K+8=";
    };
    DEP_SK_GPU_SOURCE = stdenvNoCC.mkDerivation {
      name = "sk_gpu-source";

      src = fetchzip {
        name = "sk_gpu-source-raw";
        url = "https://github.com/StereoKit/sk_gpu/releases/download/v2024.8.16/sk_gpu.v2024.8.16.zip";
        stripRoot = false;
        hash = "sha256-NeFvmCP2JII9jZfO5fj0yAWXutXAU2H6levTpyC5rpo=";
      };

      postPatch = ''
        chmod -R 755 tools/*
      '';

      dontConfigure = true;
      dontBuild = true;

      nativeBuildInputs = [
        autoPatchelfHook
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -R . $out

        runHook postInstall
      '';
    };

    LIBCLANG_PATH = "${libclang.lib}/lib";
  };

  postPatch = ''
    sk=$(echo $cargoDepsCopy/stereokit-rust-*/StereoKit)
    install -D ${cpm-cmake}/share/cpm/CPM.cmake $sk/build/cpm/CPM_0.38.7.cmake
    ln -s $DEP_SK_GPU_SOURCE $sk/sk_gpu
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    llvmPackages.libcxxClang
  ];

  buildInputs = [
    fontconfig
    libGL
    libXau
    libXdmcp
    libxkbcommon
    mesa
    openxr-loader.dev
    xorg.libX11.dev
    xorg.libXft
    xorg.libXfixes
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland compositor and display server for 3D applications";
    homepage = "https://stardustxr.org/";
    changelog = "https://github.com/StardustXR/server/releases";
    license = lib.licenses.gpl2Plus;
    mainProgram = "stardust-xr-server";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
