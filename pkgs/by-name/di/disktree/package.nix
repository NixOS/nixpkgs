{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  freetype,
  libxkbcommon,
  vulkan-loader,
  stdenv,
  wayland,
  xorg,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "disktree";
  version = "0.9.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tobi";
    repo = "disktree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B5gMkZ0LlcOGb0P1uYGaALD+QXmnfbrRZWwqbU2NrVk=";
  };

  cargoHash = "sha256-op6c26/F+m7dUCCaPEIBrU21P6muW8gU6sHt8LDG4f8=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
    libxkbcommon
    vulkan-loader
  ]
  ++ lib.optionals stdenv.isLinux [
    wayland
    xorg.libX11
    xorg.libxcb
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A treemap for finding and removing what fills your disk, for Omarchy. Rust + GPUI";
    homepage = "https://github.com/tobi/disktree";
    changelog = "https://github.com/tobi/disktree/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "disktree";
  };
})
