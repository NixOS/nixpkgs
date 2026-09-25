{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.3.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "domenkozar";
    repo = "agentaps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pHESE5ML5zeDylz07t8k1jJop/IGyIhTTffPN4dWrY0=";
  };

  cargoHash = "sha256-ko+ytnpQGLIA41+aurIcY5Rp0Aemf7Z4PFC5GdLFLvw=";

  patches = [
    # Add --version support until the next release.
    (fetchpatch {
      url = "https://github.com/domenkozar/agentaps/commit/1665c2792929226d675d427e0eef42cd3ede7a71.patch";
      hash = "sha256-+wL5G6Ln9uuWxt2fRW2QPbD54Zif51hGxcNAC3Q3f84=";
      includes = [ "src/main.rs" ];
    })
  ];

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
