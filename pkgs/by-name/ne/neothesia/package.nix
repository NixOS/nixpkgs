{
  rustPlatform,
  fetchFromGitHub,
  lib,
  ffmpeg_7,
  pkg-config,
  alsa-lib,
  wayland,
  makeWrapper,
  libxkbcommon,
  vulkan-loader,
  xorg,
}:
let
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "PolyMeilex";
    repo = "Neothesia";
    rev = "v${version}";
    hash = "sha256-qYwBSye6RYClSlWmHwuy/rxq9w5932tR33Z+o2S1l8k=";
  };
in
rustPlatform.buildRustPackage {
  pname = "neothesia";

  inherit src version;

  buildInputs = [
    ffmpeg_7
    alsa-lib
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-mXeNAVYqPsBWiUZFV/atx/xjLgFNarm2HwI7k/NaAbc=";

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
    install -Dm 644 default.sf2 $out/share/neothesia/default.sf2
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
