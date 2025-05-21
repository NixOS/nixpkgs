{
  rustPlatform,
  fetchFromGitHub,
  lib,
  ffmpeg,
  pkg-config,
  alsa-lib,
  wayland,
  makeWrapper,
  libxkbcommon,
  vulkan-loader,
  xorg,
}:
let
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "PolyMeilex";
    repo = "Neothesia";
    rev = "v${version}";
    hash = "sha256-bQ2546q+oachvuNKMJHjQzF6uv06LG+f7eFQPoAn6mw=";
  };
in
rustPlatform.buildRustPackage {
  pname = "neothesia";

  inherit src version;

  buildInputs = [
    ffmpeg
    alsa-lib
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    rustPlatform.bindgenHook
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-qIoH+YhyPXXIWFwgcJBly2KBSuVgaRg5kZtBazaTVJ0=";

  cargoBuildFlags = [
    "-p neothesia -p neothesia-cli"
  ];

  postInstall = ''
    wrapProgram $out/bin/neothesia --prefix LD_LIBRARY_PATH : "${
      lib.makeLibraryPath [
        wayland
        libxkbcommon
        vulkan-loader
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrender
      ]
    }"
    install -Dm 644 flatpak/com.github.polymeilex.neothesia.desktop $out/share/applications/com.github.polymeilex.neothesia.desktop
    install -Dm 644 flatpak/com.github.polymeilex.neothesia.png $out/share/icons/hicolor/256x256/apps/com.github.polymeilex.neothesia.png
  '';

  meta = {
    description = "Flashy Synthesia Like Software For Linux, Windows and macOS";
    homepage = "https://github.com/PolyMeilex/Neothesia";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "neothesia";
    maintainers = [
      lib.maintainers.naxdy
    ];
  };
}
