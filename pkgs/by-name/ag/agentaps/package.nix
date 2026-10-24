{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  makeWrapper,
  wrapGAppsHook4,
  versionCheckHook,
  alsa-lib,
  fontconfig,
  freetype,
  gtk4,
  libGL,
  libxcb,
  libxkbcommon,
  libxml2,
  llvmPackages,
  qt6,
  vulkan-loader,
  wayland,
  zig_0_16,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agentaps";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "agentaps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JBAIr21yk81+pSQnnNXv4hdZEUY9HngYGJP+5/Wqa2I=";
  };

  cargoHash = "sha256-K3c1FZWUE5bX56OcdO452qrQ4St0HXWZiWFBKWoyjX4=";

  zigDeps = zig_0_16.fetchDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.cargoDeps}/source-registry-0/gpui-libghostty-0.3.1/vendor/ghostty";
    fetchAll = true;
    hash = "sha256-l6BjpfE7S/q4D0BIx5p6EfdawgovZ2PtOUWH3eWEuc8=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    qt6.wrapQtAppsHook
    wrapGAppsHook4
    zig_0_16
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    gtk4
    libGL
    libxcb
    libxkbcommon
    libxml2
    llvmPackages.libcxx
    qt6.qtbase
    vulkan-loader
    wayland
  ];

  # Cargo drives the embedded Ghostty build.
  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  postConfigure = ''
    export GHOSTTY_ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
    cp -r ${finalAttrs.zigDeps} "$GHOSTTY_ZIG_GLOBAL_CACHE_DIR/p"
    chmod -R u+w "$GHOSTTY_ZIG_GLOBAL_CACHE_DIR/p"
    mkdir -p "$GHOSTTY_ZIG_GLOBAL_CACHE_DIR/tmp"
  '';

  nativeCheckInputs = [ git ];

  # The login shell test requires /bin/sh and /usr/bin/env, which are absent in the sandbox.
  checkFlags = [ "--skip=shell_env::tests::reads_path_from_a_login_shell" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  postFixup = ''
    wrapProgram "$out/bin/agentaps" \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --suffix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          libxcb
          libxkbcommon
          vulkan-loader
          wayland
        ]
      }"
  '';

  meta = {
    description = "Desktop client for Agent Client Protocol agents";
    homepage = "https://github.com/cachix/agentaps";
    changelog = "https://github.com/cachix/agentaps/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "agentaps";
    maintainers = with lib.maintainers; [ domenkozar ];
    platforms = lib.platforms.linux;
  };
})
