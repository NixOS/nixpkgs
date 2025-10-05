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
  xorg,
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
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "liana";
  version = "13.0"; # keep in sync with lianad

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    tag = "v${version}";
    hash = "sha256-zr9FZZSLPMk2d5vyZqrj12RG4UCdmkyKLjTU7XpgedE=";
  };

  cargoHash = "sha256-uLSlx1WWCcngL1WSP3jOvwFJd/gbz/g9AT6Of9rwEMw=";

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

  meta = with lib; {
    mainProgram = "liana-gui";
    description = "Bitcoin wallet leveraging on-chain timelocks for safety and recovery";
    homepage = "https://wizardsardine.com/liana";
    changelog = "https://github.com/wizardsardine/liana/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dunxen ];
    platforms = platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
