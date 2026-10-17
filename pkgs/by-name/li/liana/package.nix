{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  expat,
  fontconfig,
  freetype,
  libGL,
  udev,
  libxkbcommon,
  wayland,
  vulkan-loader,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
}:

let
  runtimeLibs = [
    expat
    fontconfig
    freetype
    freetype.dev
    libGL
    pkg-config
    udev
    wayland
    libxkbcommon
    vulkan-loader
    libx11
    libxcursor
    libxi
    libxrandr
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "liana";
  version = "15.0"; # keep in sync with lianad

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    tag = "v${version}";
    hash = "sha256-mRBhpf4Risuq4TQ1y/5lWTOxN2RMHcZ2SC2BpbsOdhA=";
  };

  cargoHash = "sha256-Mr6YOK7d6pfFliaiw2Mjj5wJvPk+6yH892uS7ksd4YU=";

  nativeBuildInputs = [
    pkg-config
    cmake
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    udev
  ];

  buildAndTestSubdir = "liana-gui";

  postInstall = ''
    install -Dm0644 ./liana-ui/static/logos/liana-app-icon.svg $out/share/icons/hicolor/scalable/apps/liana.svg
    wrapProgram $out/bin/liana-gui --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Liana";
      exec = "liana-gui";
      icon = "liana";
      desktopName = "Liana";
      comment = meta.description;
    })
  ];

  doCheck = true;

  meta = {
    mainProgram = "liana-gui";
    description = "Bitcoin wallet leveraging on-chain timelocks for safety and recovery";
    homepage = "https://wizardsardine.com/liana";
    changelog = "https://github.com/wizardsardine/liana/releases/tag/${src.rev}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dunxen ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
