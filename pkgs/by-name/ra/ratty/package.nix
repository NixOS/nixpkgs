{
  fetchFromGitHub,
  fontconfig,
  lib,
  libxcb,
  libxkbcommon,
  makeBinaryWrapper,
  pkg-config,
  rustPlatform,
  systemdLibs,
  vulkan-loader,
  wayland,
  zlib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ratty";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "ratty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vxqd5peP4dcUyhM3JYzMUohYjlnsgZXRTnerKDC5VPg=";
  };

  cargoHash = "sha256-/9ekk3B96OanoEXxRDd8eN0gx4IK0qfysOd6DkIZg+k=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    fontconfig
    libxcb
    libxkbcommon
    systemdLibs
    vulkan-loader
    wayland
    zlib
  ];

  # no tests currently, speeds up build time
  # will be changed when tests are introduced
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/ratty \
      --set LD_LIBRARY_PATH "${
        lib.makeLibraryPath [
          libxkbcommon
          vulkan-loader
          wayland
        ]
      }"
  '';

  __structuredAttrs = true;

  meta = {
    description = "GPU-rendered terminal emulator with inline 3D graphics";
    homepage = "https://ratty-term.org/";
    downloadPage = "https://github.com/orhun/ratty";
    changelog = "https://github.com/orhun/ratty/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ poz ];
    platforms = lib.platforms.linux;
    mainProgram = "ratty";
  };
})
