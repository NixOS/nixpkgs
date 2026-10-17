{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  freetype,
  libxkbcommon,
  libxcb,
  wayland,
  vulkan-loader,
  libGL,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mulu";
  version = "1.2.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yangkx1024";
    repo = "mulu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RNgEA0nnmN8s2eTz137F11AUuaVtq4eT7owGeqPVZCc=";
  };

  cargoHash = "sha256-u8/J+PHtTN/zptsf3s4rBcJOXeDQC0sHfEwJZGZzXBc=";

  # The in-app updater pings GitHub releases; updates come through nixpkgs.
  buildNoDefaultFeatures = true;

  # Upstream has no test suite; `cargo test` would only rebuild the crate graph.
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    freetype
    libxkbcommon
    libxcb
  ];

  postInstall = ''
    install -Dm644 mulu.desktop -t $out/share/applications
    for icon in linux-icons/*.png; do
      install -Dm644 "$icon" "$out/share/icons/hicolor/$(basename "$icon" .png)/apps/mulu.png"
    done
  '';

  # GPUI dlopens the graphics and windowing libraries at runtime.
  postFixup = ''
    patchelf $out/bin/mulu --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
      ]
    }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight MTP client for browsing files on Android phones and cameras";
    homepage = "https://github.com/yangkx1024/mulu";
    changelog = "https://github.com/yangkx1024/mulu/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ yangkx1024 ];
    mainProgram = "mulu";
    platforms = lib.platforms.linux;
  };
})
