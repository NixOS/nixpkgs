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
  libxrender,
  libxi,
  libxcursor,
  libx11,
  fetchpatch,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neothesia";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "PolyMeilex";
    repo = "Neothesia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5DuyWuDJ08S12C3OWhC9mLhQvPCfWMdJCRUOWtKq/+k=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/PolyMeilex/Neothesia/commit/c450689134e5e767293ae9a4878a0396e585259b.patch";
      hash = "sha256-A7GuaEHIfSFrvS1SCBWGCuh3rvb2gaaw8dQ970f6u2Y=";
    })
  ];

  buildInputs = [
    ffmpeg_7
    alsa-lib
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-gX9DlgPgrM8KukX3auxbBKpJq7QG4+kRhHSUk3eQjAQ=";

  cargoBuildFlags = [
    "-p neothesia -p neothesia-cli"
  ];

  postInstall = ''
    wrapProgram $out/bin/neothesia --prefix LD_LIBRARY_PATH : "${
      lib.makeLibraryPath [
        wayland
        libxkbcommon
        vulkan-loader
        libx11
        libxcursor
        libxi
        libxrender
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
})
