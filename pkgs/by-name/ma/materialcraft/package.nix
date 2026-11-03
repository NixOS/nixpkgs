{
  lib,
  stdenv,
  rustPlatform,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,

  nix-update-script,
}:

let
  # Loaded with dlopen by winit, wgpu and rfd (libdbus, for the file dialogs).
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    wayland
    vulkan-loader
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "materialcraft";
  version = "0.1.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "materialcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GXdLvk35t5FAgdJZKgbOfcjUnHznDPo+QiDjbLZPs88=";
  };

  cargoHash = "sha256-ajuL6CF2uD02JqQrhJZwVyapNqShlghegu8XLpccan8=";

  cargoBuildFlags = [
    "--package=materialcraft"
    "--package=materialcraft-cli"
  ];

  # MCP and automation tests bind loopback sockets.
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pkg-config
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.materialcraft.desktop \
      $out/share/applications/ai.storyteller.materialcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.materialcraft.mime.xml \
      $out/share/mime/packages/ai.storyteller.materialcraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/materialcraft
  '';

  # The `materialcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=materialcraft-cli"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Node-based procedural PBR material designer";
    homepage = "https://github.com/storytold/materialcraft";
    changelog = "https://github.com/storytold/materialcraft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "materialcraft";
  };
})
