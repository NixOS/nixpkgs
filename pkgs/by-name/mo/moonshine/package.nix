{
  _experimental-update-script-combinators,
  cmake,
  fetchFromGitHub,
  pkg-config,
  lib,
  libevdev,
  libgbm,
  libGL,
  libopus,
  libx11,
  libxkbcommon,
  libxres,
  nix-update-script,
  rustPlatform,
  shaderc,
  stdenv,
  versionCheckHook,
  vulkan-loader,
  aws-lc,
  sqlite,
}:

let
  # Fetch the C++ sources of inputtino explicitly since the inputtino-sys crate requires them to be present.
  # Revision matches Cargo.lock
  inputtino-src = fetchFromGitHub {
    owner = "games-on-whales";
    repo = "inputtino";
    rev = "d28ec79eb63324e68d73a7de22bcb5ff0a6f6bf8";
    hash = "sha256-xzDsJggQVX5e1twwNvqw5hDXei6OMYA4s5zU4zfp/H0=";
  };

  wsiArch = stdenv.hostPlatform.uname.processor;

  ferriscope-wsi = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "ferriscope-wsi";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "hgaiser";
      repo = "ferriscope";
      tag = "v${finalAttrs.version}";
      hash = "sha256-JvJgK9Gh9Poq201M5cGST+W8CNuWayynBBtd6b31TXE=";
    };

    __structuredAttrs = true;

    cargoHash = "sha256-gRBSukYIqCxwX8VVLLciHILctbQg7Og8Tw4PZYveT2Q=";

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      libgbm
      libxkbcommon
      shaderc
    ];

    cargoBuildFlags = [
      "-p"
      "ferriscope-wsi"
    ];

    checkFlags = [
      # /dev/dri/renderD128 is not accessible in the sandbox
      "--skip=shell::render::elements::gpu_tests::picked_formats_allocate_above_1440p"
    ];

    postInstall = ''
      if [[ ! -f "$out/lib/libferriscope_wsi.so" ]]; then
        echo "libferriscope_wsi.so does not exist at the expected location "
        exit 1
      fi

      mkdir -p "$out/share/vulkan/implicit_layer.d"
      sed -e "s|@ARCH@|${wsiArch}|g" \
        -e "s|@LIBRARY_PATH@|$out/lib/libferriscope_wsi.so|g" \
        tools/wsi/VkLayer_FERRISCOPE_wsi.json.in \
        > "$out/share/vulkan/implicit_layer.d/VkLayer_FERRISCOPE_wsi.${wsiArch}.json"
    '';

    meta = {
      description = "Rust implementation of gamescope";
      homepage = "https://github.com/hgaiser/ferriscope";
      license = lib.licenses.bsd2;
      platforms = lib.platforms.linux;
    };
  });
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "moonshine";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "hgaiser";
    repo = "moonshine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qxq+Xcq5It5NWwtmluUd0EiHqp5uuMndEc/UnBbWm0E=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-bAgFVFBtSuoUk7hImOUCUZc05sCb4J3oUxKCFjHwYX4=";

  cargoBuildFlags = [
    "-p"
    "moonshine"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    aws-lc
    libevdev
    libgbm
    libopus
    libxkbcommon
    shaderc
    sqlite
  ];

  postPatch = ''
    grep -q 'inputtino#${inputtino-src.rev}' Cargo.lock || {
      echo "ERROR: inputtino revision needs update (must match Cargo.lock)"
      exit 1
    }

    grep -q 'hgaiser/ferriscope/${ferriscope-wsi.src.tag}' flake.nix || {
      echo "ERROR: ferriscope-wsi tag needs update (must match flake.lock)"
      exit 1
    }

    substituteInPlace $cargoDepsCopy/*/inputtino-sys-*/build.rs \
      --replace-fail 'PathBuf::from("../../../")' 'PathBuf::from("${inputtino-src}")' \
      --replace-fail 'println!("cargo:rustc-link-lib=c++");' ""
  '';

  postInstall = ''
    install -Dm644 -t "$out/share/vulkan/implicit_layer.d" \
      "${ferriscope-wsi}/share/vulkan/implicit_layer.d/VkLayer_FERRISCOPE_wsi.${wsiArch}.json"

    # udev rules for input
    install -Dm644 dist/60-moonshine.rules "$out/lib/udev/rules.d/60-moonshine.rules"

    # polkit rule for sleep inhibitor
    install -Dm644 dist/50-moonshine-inhibit-sleep.rules \
      "$out/share/polkit-1/rules.d/50-moonshine-inhibit-sleep.rules"
  '';

  postFixup = ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        # Required by Steam focus protocol (x11_focus.rs)
        libx11
        libxres
      ]
    } "$out/bin/moonshine"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # NOTE: If upstream bumps inputtino, this must be manually updated above
  passthru = {
    inherit ferriscope-wsi;
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (nix-update-script { attrPath = "moonshine.ferriscope-wsi"; })
    ];
  };

  meta = {
    description = "Headless streaming server for Moonlight clients";
    longDescription = ''
      Moonshine lets you stream games from your PC to any device running Moonlight.
      Your keyboard, mouse, and controller inputs are sent back to the host so you
      can play games remotely as if you were sitting in front of it.
    '';
    homepage = "https://github.com/hgaiser/moonshine";
    changelog = "https://github.com/hgaiser/moonshine/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      neobrain
      anish
    ];
    mainProgram = "moonshine";
    platforms = lib.platforms.linux;
  };
})
