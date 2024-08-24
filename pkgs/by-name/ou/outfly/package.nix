{
  stdenvNoCC,
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
  version = "0.13.0";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "outfly";
    repo = "outfly";
    rev = "v${version}";
    hash = "sha256-A43lLG5K9mEhRsv+paQa1so4Cyk75vyocAyU3k6wDiQ=";
  };

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "embed_assets"
    "x11"
    "wayland"
  ];

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
  doCheck = false;

  postFixup = ''
    patchelf $out/bin/outfly \
    --add-rpath ${lib.makeLibraryPath runtimeInputs}
  '';

  cargoHash = "sha256-6qd52F5ub1aFxJHeFEysy6ZOOuqmcsCiGHJNPp6pwhA=";

  desktopItems = [
    (makeDesktopItem {
      name = "outfly";
      exec = "outfly";
      desktopName = "OutFly";
      categories = [ "Game" ];
    })
  ];
  meta = {
    description = "A breathtaking 3D space game in the rings of Jupiter";
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
