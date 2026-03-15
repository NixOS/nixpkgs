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
}:
let
  linkLibPath = lib.makeLibraryPath [
    libGL
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raphael-xiv";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "KonaeAkira";
    repo = "raphael-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-icCCSHZqQEYCIpcqB5iTOHYL0pzRN+0x/r/nauPiFZ0=";
  };

  cargoHash = "sha256-mua7YKU5Ujj8u3ZLI3y073JGRRN6dAUct+9YA4M8Ngk=";

  cargoBuildFlags = [
    "--package"
    "raphael-xiv"
    "--package"
    "raphael-cli"
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --set-rpath "${linkLibPath}" "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}"
  '';

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
