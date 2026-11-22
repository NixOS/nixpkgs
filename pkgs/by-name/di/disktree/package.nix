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
  gitMinimal,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "disktree";
  version = "0.11.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tobi";
    repo = "disktree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b7VP3VgOS+zUTR2bhOh6JNcN5mIIeHL/fe3u/eHC+X4=";
  };

  cargoHash = "sha256-k+iLvOS+6o5oC+JcG9BJ3UUAzZAQpcpNelKCXsDx0Fw=";

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
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  meta = {
    description = "Disk usage treemap for finding and removing files";
    homepage = "https://github.com/tobi/disktree";
    changelog = "https://github.com/tobi/disktree/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      domenkozar
      kleinbem
    ];
    mainProgram = "disktree";
    platforms = lib.platforms.linux;
  };
})
