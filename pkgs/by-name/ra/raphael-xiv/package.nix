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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raphael-xiv";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "KonaeAkira";
    repo = "raphael-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pHKvQmrg7mBzC88geYbRgApAtSsNT1hgFXZIPd1Thzs=";
  };

  cargoHash = "sha256-qoxSEAWn3LTDjAzZzwH9KrITKzdPo/rQItCy0ikve6w=";

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

  # The GUI application needs most of the buildInputs at runtime, with the exception of libGL
  postFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath (lib.lists.remove libGL finalAttrs.buildInputs)}" \
      "$out/bin/raphael-xiv"
  '';

  __structuredAttrs = true;

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
