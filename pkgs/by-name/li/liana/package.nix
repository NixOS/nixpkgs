{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, cmake
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, expat
, fontconfig
, freetype
, libGL
, systemd
, vulkan-loader
, xorg
, withGui ? true
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
  pname = if withGui then "liana" else "lianad";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${version}";
    hash = "sha256-RkZ2HSN7IjwN3tD0UhpMeQeqkb+Y79kSWnjJZ5KPbQk=";
  };

  cargoLock = if withGui then {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "liana-5.0.0" = "sha256-wePqsVpMBRP2eJZd8W05CaeesqY5g/rnr4OonmRzeeM=";
      "iced_futures-0.6.0" = "sha256-ejkAxU6DwiX1/119eA0GRapSmz7dqwx9M0uMwyDHATQ=";
    };
  } else null;
  cargoSha256 = if withGui then null else "sha256-6r8G4sO/aDO5VyJbmbdFz3W2b8ZmulXJZtnz8IAwcaU=";

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

  sourceRoot = if withGui then "${src.name}/gui" else null;

  postInstall = if withGui then ''
    install -Dm0644 ./ui/static/logos/liana-app-icon.svg $out/share/icons/hicolor/scalable/apps/liana.svg
    wrapProgram $out/bin/liana-gui --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
  '' else ''
    install -Dm0644 ./contrib/lianad_config_example.toml $out/etc/liana/config.toml
  '';

  desktopItems = if withGui then [
    (makeDesktopItem {
      name = "Liana";
      exec = "liana-gui";
      icon = "liana";
      desktopName = "Liana";
      comment = meta.description;
    })
  ] else null;

  doCheck = if withGui then true else false;

  meta = with lib; {
    mainProgram = if withGui then "liana-gui" else "lianad";
    description = "A Bitcoin wallet leveraging on-chain timelocks for safety and recovery";
    homepage = "https://wizardsardine.com/liana";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dunxen ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
