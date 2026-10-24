{
  lib,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  libxcb,
  libXcursor,
  libX11,
  xcbutilwm,
  libGL,
  libjack2,
  libxkbcommon,
  python3,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "hue";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bljustice";
    repo = "hue";
    rev = "bf73d7fd620e80bd98082322a70305e14fd1f75a";
    hash = "sha256-rffYEh2qEoT9HzBjNZxZbjfSJEH/eiAuJVBAkJ7ZnBU=";
  };

  patches = [
    # These patches are required because the old versions of these dependencies do not
    # play nicely on NixOS - so they were updated. Unfortunately, these updates also came with
    # API updates, so I had to patch those too myself.
    ./cargo-toml.patch
    ./xtask-cargo-toml.patch
    ./src-editor.patch
    ./src-gui-analyzer.patch
  ];

  cargoPatches = [
    ./cargo-lock.patch
  ];

  cargoHash = "sha256-ZX9yunKgabAnKvMUk82qgIuYLGCjhWnYKDXHy79lCXg=";

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    alsa-lib
    libGL
    libjack2
    libxkbcommon
    libxcb
    libXcursor
    libX11
    xcbutilwm
  ];

  buildPhase = ''
    runHook preBuild

     cargo xtask bundle hue --release

     runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

     mkdir -p $out/lib/vst3
     mkdir -p $out/lib/clap
     cp -r target/bundled/hue.vst3 $out/lib/vst3
     install -Dm755 target/bundled/hue.clap $out/lib/clap

     runHook postInstall
  '';

  meta = {
    description = "Audio plugin that helps mix different noise types into an audio signal";
    homepage = "https://github.com/bljustice/hue";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
