{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
  craft-fonts,

  nix-update-script,
}:

let
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    wayland
    vulkan-loader
    libxrandr
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "craft-anything";
  version = "0.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craft-fonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-anything";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f6N221UKH5t62iWK6NGri3No7d338V64iQWShcxboR0=";
  };

  cargoHash = "sha256-Ft2eRVkVx8fTHKCBRtExFEo0lSc9SolyLiUz6rM6u1M=";

  cargoBuildFlags = [
    "--package=craft-anything"
    "--package=craft-anything-cli"
  ];

  # The desktop app runs GPU-backed UI tests; keep CI to the CLI crate.
  cargoTestFlags = [
    "--package=craft-anything-cli"
  ];

  nativeBuildInputs = [
    pkg-config
    patchelf
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.craft-anything.desktop \
      $out/share/applications/ai.storyteller.craft-anything.desktop
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/craft-anything
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Understand how software works and craft your own — reverse engineering workbench";
    homepage = "https://github.com/storytold/craft-anything";
    changelog = "https://github.com/storytold/craft-anything/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
      ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "craft-anything";
    platforms = rustc.meta.platforms;
  };
})
