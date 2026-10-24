{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libGL,
  libxkbcommon,
  wayland,
  libx11,
  libxcursor,
  libxi,
  vulkan-loader,
  copyDesktopItems,
  makeDesktopItem,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raphael-xiv";
  version = "0.28.6";

  src = fetchFromGitHub {
    owner = "KonaeAkira";
    repo = "raphael-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YsHOakC1lSwozEO3I5RqPIYuoxNFOvoOrb81dexv9qc=";
  };

  cargoHash = "sha256-CRGBPDt3fCDfmSTY6sPzBU9YocJ5G5wewQ5P6eFZlV0=";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    libGL
    libxkbcommon
    libx11
    libxcursor
    libxi
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
  ];

  cargoBuildFlags = [
    "--package"
    "raphael-xiv"
    "--package"
    "raphael-cli"
  ];

  preInstall = ''
    mkdir -p "$out/share/icons/hicolor/64x64/apps"
    cp assets/favicon-64x64.png "$out/share/icons/hicolor/64x64/apps/raphael-xiv.png"
  '';

  # The GUI application needs most of the buildInputs at runtime, with the exception of libGL
  postFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath (lib.lists.remove libGL finalAttrs.buildInputs)}" \
      "$out/bin/raphael-xiv"
  '';

  __structuredAttrs = true;

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = "raphael-xiv";
      icon = "raphael-xiv";
      desktopName = "Raphael XIV";
      comment = finalAttrs.meta.description;
    })
  ];

  meta = {
    description = "Crafting macro solver for Final Fantasy XIV";
    homepage = "https://github.com/KonaeAkira/raphael-rs";
    changelog = "https://github.com/KonaeAkira/raphael-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hekazu ];
    mainProgram = "raphael-xiv";
    platforms = lib.platforms.all;
  };
})
