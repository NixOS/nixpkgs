{
  lib,
  makeWrapper,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
  wayland-protocols,
  libGL,
  vulkan-loader,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chameleos";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Treeniks";
    repo = "chameleos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iIFUEUdnX+PtYAs5KRMn5c0vCuHRAkOxhP/PuveLC74=";
  };

  cargoHash = "sha256-3gy8X9QUIVFBpCtLDXL/7eDBEQHtRO8v1t8WnkzPyj4=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    git
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libGL
    vulkan-loader
  ];

  postInstall = ''
    wrapProgram $out/bin/chameleos \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          vulkan-loader
        ]
      }
  '';

  meta = {
    description = "Screen annotation tool for niri and Hyprland";
    homepage = "https://github.com/Treeniks/chameleos";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lonerOrz ];
    mainProgram = "chameleos";
  };
})
