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
  systemd,
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
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "liana";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${version}";
    hash = "sha256-RkZ2HSN7IjwN3tD0UhpMeQeqkb+Y79kSWnjJZ5KPbQk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "liana-5.0.0" = "sha256-wePqsVpMBRP2eJZd8W05CaeesqY5g/rnr4OonmRzeeM=";
      "iced_futures-0.6.0" = "sha256-ejkAxU6DwiX1/119eA0GRapSmz7dqwx9M0uMwyDHATQ=";
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
    systemd
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ dunxen ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
