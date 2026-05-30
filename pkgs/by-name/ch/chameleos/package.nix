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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chameleos";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Treeniks";
    repo = "chameleos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zCAYEtDYJm9A+HC9M2XLtz47q+6dcBOVPgh4lmp4z/k=";
  };

  cargoHash = "sha256-zBEu/T17W7dwz8jxnXm2NsHaVZo1wDFSW75yiYfRIoY=";

  postPatch = ''
    substituteInPlace build.rs --replace-fail '"git"' '"echo"'
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
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
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lonerOrz ];
    mainProgram = "chameleos";
  };
})
