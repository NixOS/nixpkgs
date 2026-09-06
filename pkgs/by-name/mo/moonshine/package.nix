{
  addDriverRunpath,
  cmake,
  fetchFromGitHub,
  lib,
  libdrm,
  libevdev,
  libgbm,
  libglvnd,
  libopus,
  libpulseaudio,
  libx11,
  libxkbcommon,
  libxres,
  nixosTests,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  vulkan-loader,
  wayland,
}:

let
  # Fetch the C++ sources of inputtino explicitly since the inputtino-sys crate
  # expects the repository root to be available. The revision matches Cargo.lock.
  inputtino-src = fetchFromGitHub {
    owner = "games-on-whales";
    repo = "inputtino";
    rev = "d28ec79eb63324e68d73a7de22bcb5ff0a6f6bf8";
    hash = "sha256-xzDsJggQVX5e1twwNvqw5hDXei6OMYA4s5zU4zfp/H0=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "moonshine";
  version = "0.16.1";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hgaiser";
    repo = "moonshine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CmSOU263HD4qDFwGRxyozo2u2BlM+bT8AE7EwFPEhnA=";
  };

  cargoHash = "sha256-g9X9tiO+mUW4eTYi16nvesHIvWsQgAft7ZLEK1/CQHg=";

  # Also installs moonshine-bench and builds the WSI layer.
  cargoBuildFlags = [ "--workspace" ];

  nativeBuildInputs = [
    addDriverRunpath
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];
  dontUseCmakeConfigure = true;

  # System libraries required by upstream's DRM/GBM/EGL, PulseAudio, and Vulkan support.
  buildInputs = [
    libdrm
    libevdev
    libgbm
    libglvnd
    libopus
    libpulseaudio
    libxkbcommon
    vulkan-loader
    wayland
  ];

  postPatch = ''
    # Keep the separately fetched C++ tree in lock-step with the git crate.
    grep -Fq "inputtino#${inputtino-src.rev}" Cargo.lock || {
      echo "ERROR: inputtino revision needs update (must match Cargo.lock)" >&2
      exit 1
    }

    substituteInPlace "$cargoDepsCopy"/*/inputtino-sys-*/build.rs \
      --replace-fail 'PathBuf::from("../../../")' 'PathBuf::from("${inputtino-src}")' \
      --replace-fail 'println!("cargo:rustc-link-lib=c++");' ""
  '';

  postInstall = ''
    manifest="$out/share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json"
    install -Dm644 dist/VkLayer_moonshine_wsi.json "$manifest"
    substituteInPlace "$manifest" \
      --replace-fail /usr/lib/moonshine/vulkan-layers/libmoonshine_wsi.so \
      $out/lib/libmoonshine_wsi.so

    install -Dm644 dist/60-moonshine.rules $out/lib/udev/rules.d/60-moonshine.rules
    install -Dm644 dist/50-moonshine-inhibit-sleep.rules \
      $out/share/polkit-1/rules.d/50-moonshine-inhibit-sleep.rules
  '';

  postFixup = ''
    for executable in $out/bin/*; do
      patchelf --add-rpath ${
        lib.makeLibraryPath [
          vulkan-loader
          libglvnd
          # Steam focus detection uses dlopen, so auto-RPATH cannot find these.
          libx11
          libxres
        ]
      } "$executable"
      addDriverRunpath "$executable"
    done
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) moonshine; };
    updateScript = nix-update-script { };
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
      philocalyst
    ];
    mainProgram = "moonshine";
    platforms = lib.platforms.linux;
  };
})
