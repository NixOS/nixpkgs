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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Treeniks";
    repo = "chameleos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jF4szo4+f7K+luhHVw4DQYte7E9S3A4qfnEzhN9uYyM=";
  };

  cargoHash = "sha256-6LPu5Lvr9Gieu1l78RtsKr4WzxuPQEE3DPnR+01Luew=";

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
