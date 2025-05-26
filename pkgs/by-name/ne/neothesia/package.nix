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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "PolyMeilex";
    repo = "Neothesia";
    rev = "v${version}";
    hash = "sha256-JD1jQ/a6GHtB/d/fRMCiE4ZOO676BIiZ980VIYUloU0=";
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
  cargoHash = "sha256-OYdKuYOL3X6eqVYANvmfTRA8TGd4+QLg0zodDH0jxXk=";

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
