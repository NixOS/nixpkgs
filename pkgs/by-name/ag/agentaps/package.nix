{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  makeWrapper,
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
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "domenkozar";
    repo = "agentaps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rc1zOahctoi9uaqY4EHkM62e3+WB7c+66WER/kW2+OQ=";
  };

  cargoHash = "sha256-LODA62qjhzxscLb9G/HCAG21aFYTlwaAMVfFYqdOLsI=";

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
