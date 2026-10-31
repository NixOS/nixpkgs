{
  lib,
  rustPlatform,
  fetchFromGitHub,
  dbus,
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
  qt6,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agentaps";
  version = "0.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "agentaps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5221voW4impMuIoOaNi7xhFU0tb3JlnxwP5E99ZX0O4=";
  };

  cargoHash = "sha256-E0jX6wQDqwPm25pOXza2L3JJ75PkjXDzgeSFNEInjHg=";

  postPatch = ''
    substituteInPlace src/system_notifications/tests.rs \
      --replace-fail '"--session"' '"--config-file=${dbus}/share/dbus-1/session.conf"'
  '';

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    qt6.wrapQtAppsHook
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
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

  nativeCheckInputs = [
    dbus
    git
  ];

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
