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
    rev = "f4ce2b0df536ef309e9ff318f75b460f7097d7c1";
    hash = "sha256-mAAXbIK7aNSLyN7OZX9YeesMvT6OZmT9uAx0md6pyRM=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "moonshine";
  version = "0.13.5";

  src = fetchFromGitHub {
    owner = "hgaiser";
    repo = "moonshine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DwRUVMAm4fSqZu6jECeasiRpnwBt7thWkXzztNRIjcs=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-M/VNPnccqK3koa0TeMd+tml79O7BKLxHmrGcGPemGhI=";

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
    maintainers = with lib.maintainers; [ neobrain ];
    mainProgram = "moonshine";
    platforms = lib.platforms.linux;
  };
})
