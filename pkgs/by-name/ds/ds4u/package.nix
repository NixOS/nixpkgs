{
  lib,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  systemd,
  hidapi,
  openssl,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:
let
  rpathLibs = [
    libxkbcommon
    vulkan-loader
    wayland
    openssl
    systemd
    hidapi
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ds4u";
  version = "0.0.1";
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "deadYokai";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-3DPL6OCIOJQklRZvb2hhS/rfit8l7gcRsXjJLKC8RFk=";
  };

  cargoPatches = [
    ./0001-provide-cargo-lock.patch
    ./0002-eframe-wgpu.patch
  ];

  cargoHash = "sha256-bsUAg8N7pAQWCfGHtYqpoK153e9Fxy3pKimLPp7wFDk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = rpathLibs;

  postInstall = ''
    patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/ds4u
  '';

  dontPatchELF = true;

  meta = {
    description = "Native Linux Gui tool for configuring DualSense controllers";
    homepage = "https://gitlab.com/deadYokai/ds4u";
    license = lib.licenses.mit;
    mainProgram = "ds4u";
    maintainers = with lib.maintainers; [ cakeforcat ];
    platforms = lib.platforms.linux;
  };
})
