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
  version = "0.6.1";

  __structuredAttrs = true;

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-anything";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dyVrrYM8X6HK5V3SfCGtAgkL3sSU2cPZqMA89WWkOm4=";
  };

  cargoHash = "sha256-jQV/FdM8TT2CyQ8OiK82Tmbmhg6YmToZ0XqKS7k7K1U=";

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
    description = "Understand how software works and craft your own, reverse engineering workbench";
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
  };
})
