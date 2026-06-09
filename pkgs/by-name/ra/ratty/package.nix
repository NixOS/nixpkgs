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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "ratty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P9cHNK6yYa4JjoxW8I06nuS4e/qitNVXPDIBSGWa+AA=";
  };

  cargoHash = "sha256-ICNkUmRLtx6ay1ay/TtnLLkzv5KN+C9F8NNHwxmC/6M=";

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
