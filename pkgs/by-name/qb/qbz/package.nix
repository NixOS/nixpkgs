{
  alsa-lib,
  autoPatchelfHook,
  clang,
  cmake,
  fetchFromGitHub,
  fontconfig,
  freetype,
  lib,
  libglvnd,
  libjack2,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  llvmPackages,
  makeWrapper,
  nasm,
  nix-update-script,
  pipewire, # pw-metadata/pw-dump for bit-perfect sample rate queries and DAC detection
  pkg-config,
  pulseaudio, # pactl for PipeWire device enumeration and sink routing
  rustPlatform,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qbz";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "vicrodh";
    repo = "qbz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zseGL7IcH/fdc4TDVwU3Tml1X6wCvSaYCji5D5RxAuA=";
  };

  cargoHash = "sha256-FPDyn61rO/hW9gEUU/yo+mXhnamwwXU1mj3wGQpHA3o=";
  cargoRoot = "crates";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    libjack2
  ];

  runtimeDependencies = [
    libglvnd
    libxkbcommon
    libx11
    libxcursor
    libxi
    vulkan-loader
    wayland
  ];

  # The generated Slint UI module is a single very large compilation unit;
  # running the test profile on top of the build doubles wall time and memory
  # for no packaging value. Engine crates are tested in upstream CI.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/qbz \
      --prefix PATH : ${
        lib.makeBinPath [
          pulseaudio
          pipewire
        ]
      }

    install -Dm644 $src/packaging/linux/qbz.desktop \
      $out/share/applications/qbz.desktop
    for size in 32 48 64 128 256 512; do
      install -Dm644 $src/packaging/icons/"$size"x"$size".png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/qbz.png
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native, full-featured hi-fi Qobuz desktop player for Linux, with fast, bit-perfect audio playback";
    homepage = "https://qbz.lol";
    changelog = "https://github.com/vicrodh/qbz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felixsinger
      vicrodh
      fpletz
    ];
    mainProgram = "qbz";
    platforms = lib.platforms.linux;
  };
})
