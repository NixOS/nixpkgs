{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  desktop-file-utils,
  makeBinaryWrapper,
  fontconfig,
  freetype,
  libGL,
  libxcb,
  libxkbcommon,
  openssl,
  vulkan-loader,
  wayland,
  git,
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
    desktop-file-utils
    makeBinaryWrapper
  ];

  buildInputs = [
    fontconfig
    freetype
    libGL
    libxcb
    libxkbcommon
    openssl
    vulkan-loader
    wayland
  ];

  cargoBuildFlags = [ "--package=disktree-app" ];
  cargoTestFlags = [ "--package=disktree-core" ];

  postInstall = ''
    install -Dm644 assets/disktree.svg \
      "$out/share/icons/hicolor/scalable/apps/disktree.svg"
    install -d "$out/share/applications"
    substitute packaging/disktree.desktop.in \
      "$out/share/applications/disktree.desktop" \
      --replace-fail '@BINDIR@' "$out/bin" \
      --replace-fail '@VERSION@' '${finalAttrs.version}'
    desktop-file-validate "$out/share/applications/disktree.desktop"
  '';

  postFixup = ''
    patchelf "$out/bin/disktree" --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
      ]
    }
    wrapProgram "$out/bin/disktree" \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = {
    description = "Disk usage treemap for finding and removing files";
    homepage = "https://github.com/tobi/disktree";
    changelog = "https://github.com/tobi/disktree/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ domenkozar ];
    mainProgram = "disktree";
    platforms = lib.platforms.linux;
  };
})
