{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  makeWrapper,
  versionCheckHook,
  fontconfig,
  freetype,
  libGL,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agentaps";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "domenkozar";
    repo = "agentaps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/DIcohzFT0Rm6alPhBnuvJuKh6lAHwDkZJ3jwUCyDZA=";
  };

  cargoHash = "sha256-R2VPjxwElvLPbikwuxILwV7ShSOy3mJjqinaK8dNipk=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
    libGL
    libxcb
    libxkbcommon
    vulkan-loader
    wayland
  ];

  nativeCheckInputs = [ git ];

  # The login shell test requires /bin/sh and /usr/bin/env, which are absent in the sandbox.
  checkFlags = [ "--skip=shell_env::tests::reads_path_from_a_login_shell" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  postFixup = ''
    wrapProgram "$out/bin/agentaps" \
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
