{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  makeWrapper,
  wrapGAppsHook4,
  versionCheckHook,
  fontconfig,
  freetype,
  gtk4,
  libGL,
  libxcb,
  libxkbcommon,
  qt6,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agentaps";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "domenkozar";
    repo = "agentaps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nPA3kRbWyWWUa8L/dVGXaHCQ9onKL0Loe5mxE+mIfQM=";
  };

  cargoHash = "sha256-wg56HjRsGm0noQRD5hdHQkmbe56h3JHfZunuPzko66I=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    qt6.wrapQtAppsHook
    wrapGAppsHook4
  ];

  buildInputs = [
    fontconfig
    freetype
    gtk4
    libGL
    libxcb
    libxkbcommon
    qt6.qtbase
    vulkan-loader
    wayland
  ];

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
    homepage = "https://github.com/domenkozar/agentaps";
    changelog = "https://github.com/domenkozar/agentaps/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "agentaps";
    maintainers = with lib.maintainers; [ domenkozar ];
    platforms = lib.platforms.linux;
  };
})
