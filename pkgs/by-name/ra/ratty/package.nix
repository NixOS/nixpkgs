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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "ratty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iim0aRy97ilzBE5FLNOD3rVscMeX+9h4tKyzrssM3wM=";
  };

  cargoHash = "sha256-Ol2+aeNx4nX5ngj05EDYEPhB4qZbK/AKq+V3nQsbruc=";

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
