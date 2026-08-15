{
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
  versionCheckHook,
  vulkan-loader,
  wayland,
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
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "moonshine";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "hgaiser";
    repo = "moonshine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TvL3s738wooQwZfBKyCqp0V8qcYFtJL98tsxlSX8fLM=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-PAC8PcGOXxFNN8Eeiik4JrXeH2H+YcqRaBpJVtUoZ44=";

  # Build Moonshine binary and Vulkan layer
  cargoBuildFlags = [
    "-p"
    "moonshine"
    "-p"
    "moonshine-wsi"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libevdev
    libgbm
    libopus
    libxkbcommon
    wayland
  ];

  # Patch build.rs from inputtino-sys with the C++ inputtino sources.
  # Also drop the unneeded libc++ dependency.
  postPatch = ''
    grep -q 'inputtino#${inputtino-src.rev}' Cargo.lock || {
      echo "ERROR: inputtino revision needs update (must match Cargo.lock)"
      exit 1
    }

    substituteInPlace $cargoDepsCopy/*/inputtino-sys-*/build.rs \
      --replace-fail 'PathBuf::from("../../../")' 'PathBuf::from("${inputtino-src}")' \
      --replace-fail 'println!("cargo:rustc-link-lib=c++");' ""
  '';

  postInstall = ''
    # Setup implicit Vulkan layer manifest as required by Moonshine
    install -d "$out/share/vulkan/implicit_layer.d"
    substitute dist/VkLayer_moonshine_wsi.json \
      "$out/share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json" \
      --replace-fail /usr/lib/moonshine/vulkan-layers/libmoonshine_wsi.so \
        "$out/lib/libmoonshine_wsi.so"

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
  passthru.updateScript = nix-update-script { };

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
