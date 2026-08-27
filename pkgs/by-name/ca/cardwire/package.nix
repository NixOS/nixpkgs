{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  hwdata,
  libdrm,
  bpf-linker,
  pkg-config,
  nixosTests,
  makeBinaryWrapper,
  udev,
  wayland,
  libxkbcommon,
  vulkan-loader,
  libGL,
  installShellFiles,
  libxcb,
  libglvnd,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cardwire";
  version = "0.12.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "opengamingcollective";
    repo = "cardwire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WuXFztiy6G2HYCu3KpKrjR8YCpcLePfGEZ+f71x1WnM=";
  };
  cargoHash = "sha256-8eJSxL9RkHtbUxXuKPvyxhvSJD/0JeNaEM/oZf0n2Q4=";

  postPatch = ''
    # Workaround to build cardwire-ebpf, when RUSTC_BOOTSTRAP is set to 1
    # aya-build appends build_std to the cargo args, removing this
    # make the crate builds
    # <https://github.com/aya-rs/aya/blob/15a0de1b363e51d55d0fca4245df54a61e8d5521/aya-build/src/lib.rs#L151-L172>
    substituteInPlace ../cardwire-*-vendor/*/aya-build-*/src/lib.rs \
      --replace-fail "if use_build_std" "if !use_build_std"

    substituteInPlace crates/cardwire-daemon/src/core/pci/pci_device.rs \
      --replace-fail "/usr/share/hwdata/pci.ids" "${hwdata}/share/hwdata/pci.ids"

    substituteInPlace crates/cardwire-daemon/src/core/gpu/device_info.rs \
      --replace-fail "/usr/share/libdrm/amdgpu.ids" "${libdrm}/share/libdrm/amdgpu.ids"
  '';

  env = {
    RUSTFLAGS = "-C target-feature=";
    RUSTC_BOOTSTRAP = 1;
  };

  nativeBuildInputs = [
    pkg-config
    bpf-linker
    makeBinaryWrapper
    installShellFiles
  ];

  buildInputs = [
    libxcb
    udev
  ];

  postInstall = ''
    install -Dm444 ./assets/org.opengamingcollective.cardwire.conf \
      $out/share/dbus-1/system.d/org.opengamingcollective.cardwire.conf

    install -Dm444 ./assets/org.opengamingcollective.cardwire.metainfo.xml \
      $out/share/metainfo/org.opengamingcollective.cardwire.metainfo.xml

    install -Dm444 ./assets/cardwire-gui.desktop \
      $out/share/applications/cardwire-gui.desktop

    for icon in ./assets/icons/*.svg; do
      install -Dm444 "$icon" "$out/share/icons/hicolor/scalable/apps/$(basename "$icon")"
    done

    wrapProgram $out/bin/cardwired \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          vulkan-loader
          libglvnd
        ]
      }

    wrapProgram $out/bin/cardwire-gui \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
          vulkan-loader
          libGL
        ]
      }

  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cardwire \
      --fish <($out/bin/cardwire completion fish) \
      --bash <($out/bin/cardwire completion bash) \
      --zsh <($out/bin/cardwire completion zsh)
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.cardwire = nixosTests.cardwire;

  meta = {
    description = "GPU manager for laptop and workstation";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    homepage = "https://opengamingcollective.github.io/cardwire/";
    changelog = "https://github.com/OpenGamingCollective/cardwire/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      luytan
    ];
    mainProgram = "cardwire";
  };
})
