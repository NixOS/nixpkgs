{
  lib,
  fetchFromGitea,
  rustPlatform,
  makeDesktopItem,
  pkg-config,
  libxkbcommon,
  alsa-lib,
  libGL,
  vulkan-loader,
  wayland,
  libXrandr,
  libXcursor,
  libX11,
  libXi,
}:

rustPlatform.buildRustPackage rec {
  pname = "outfly";
  version = "0.14.0";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "outfly";
    repo = "outfly";
    rev = "refs/tags/v${version}";
    hash = "sha256-FRvu3FgbT3i5888ll573nhb7naYx04Oi8nrcfgEHxUo=";
  };

  runtimeInputs = [
    libxkbcommon
    libGL
    libXrandr
    libX11
    vulkan-loader
  ];

  buildInputs = [
    alsa-lib.dev
    libXcursor
    libXi
    wayland
  ];

  nativeBuildInputs = [ pkg-config ];
  doCheck = false; # no meaningful tests

  postFixup = ''
    patchelf $out/bin/outfly \
    --add-rpath ${lib.makeLibraryPath runtimeInputs}
  '';

  cargoHash = "sha256-5t6PPlfV/INqb4knz1Bv6dqw47RxUmVO0DSlQNUIQL4=";

  desktopItems = [
    (makeDesktopItem {
      name = "outfly";
      exec = "outfly";
      desktopName = "OutFly";
      categories = [ "Game" ];
    })
  ];
  meta = {
    description = "Breathtaking 3D space game in the rings of Jupiter";
    homepage = "https://yunicode.itch.io/outfly";
    downloadPage = "https://codeberg.org/outfly/outfly/releases";
    changelog = "https://codeberg.org/outfly/outfly/releases/tag/v${version}";
    license = with lib.licenses; [
      cc-by-30
      cc-by-40
      cc-by-sa-20
      cc-by-sa-30
      cc0
      gpl3
      ofl
      publicDomain
    ];
    maintainers = with lib.maintainers; [ _71rd ];
    mainProgram = "outfly";
  };
}
