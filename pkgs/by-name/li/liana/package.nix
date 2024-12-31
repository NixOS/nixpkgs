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
  version = "8.0"; # keep in sync with lianad

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${version}";
    hash = "sha256-2aIaRZNIRgFdA+NVnzOkEE3kYA15CoNBrsNGBhIz0nU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pjvJ+UNM/2g2BDLptjEs6XVukScBB5miDx55zwHJ/C4=";

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

  sourceRoot = "${src.name}/gui";

  postInstall = ''
    install -Dm0644 ./ui/static/logos/liana-app-icon.svg $out/share/icons/hicolor/scalable/apps/liana.svg
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
    description = "A Bitcoin wallet leveraging on-chain timelocks for safety and recovery";
    homepage = "https://wizardsardine.com/liana";
    changelog = "https://github.com/wizardsardine/liana/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dunxen ];
    platforms = platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
