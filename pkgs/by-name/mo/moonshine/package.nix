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
  libxkbcommon,
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
  version = "0.15.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hgaiser";
    repo = "moonshine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TvL3s738wooQwZfBKyCqp0V8qcYFtJL98tsxlSX8fLM=";
  };

  cargoHash = "sha256-PAC8PcGOXxFNN8Eeiik4JrXeH2H+YcqRaBpJVtUoZ44=";

  # Also installs moonshine-bench and builds the WSI layer.
  cargoBuildFlags = [ "--workspace" ];

  nativeBuildInputs = [
    addDriverRunpath
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];
  dontUseCmakeConfigure = true;

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

  # The integration tests exercise Vulkan, uinput, and a running systemd user
  # manager; those devices and services are deliberately absent in a Nix build sandbox.
  doCheck = false;

  postPatch = ''
    # Keep the separately fetched C++ tree in lock-step with the git crate.
    grep -Fq "inputtino#${inputtino-src.rev}" Cargo.lock

    substituteInPlace "$cargoDepsCopy"/*/inputtino-sys-*/build.rs \
      --replace-fail 'PathBuf::from("../../../")' 'PathBuf::from("${inputtino-src}")' \
      --replace-fail 'println!("cargo:rustc-link-lib=c++");' ""
  '';

  postInstall = ''
    for artifact in \
      $out/bin/moonshine \
      $out/bin/moonshine-bench \
      $out/lib/libmoonshine_wsi.so
    do
      test -f "$artifact"
    done

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
