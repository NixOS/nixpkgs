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
  version = "6.0"; # keep in sync with lianad

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${version}";
    hash = "sha256-LLDgo4GoRTVYt72IT0II7O5wiMDrvJhe0f2yjzxQgsE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "liana-6.0.0" = "sha256-04jER209Q9xj9HJ6cLXuK3a2b6fIjAYI+X0+J8noP6A=";
      "iced_futures-0.12.3" = "sha256-ztWEde3bJpT8lmk+pNhj/v2cpw/z3TNvzCSvEXwinKQ=";
    };
  };

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
