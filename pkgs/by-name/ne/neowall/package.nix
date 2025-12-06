{
  stdenv,
  gcc,
  pkg-config,
  fetchFromGitHub,
  lib,
  libglvnd,
  mesa,
  libpng,
  libjpeg,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finallAttrs: {
  pname = "neowall";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "1ay1";
    repo = "neowall";
    tag = "v${finallAttrs.version}";
    hash = "sha256-q/M79ol4l4YIsewP50/6I2C5zKmF1Bc4mgIC896qxPY=";
  };

  PKG_CONFIG_PATH = lib.strings.makeSearchPath "lib/pkgconfig" [
    mesa
    libglvnd
    wayland
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    gcc
  ];

  buildInputs = [
    wayland
    mesa
    libglvnd
    libpng
    libjpeg
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 build/bin/neowall $out/bin/neowall

    mkdir -p $out/share/neowall
    install -Dm644 config/config.vibe $out/share/neowall/config.vibe
    install -Dm644 config/neowall.vibe $out/share/neowall/neowall.vibe

    mkdir -p $out/share/neowall/shaders
    install -m644 examples/shaders/*.glsl $out/share/neowall/shaders/

    mkdir -p $out/share/licenses/${finallAttrs.pname}
    install -m644 LICENSE $out/share/licenses/${finallAttrs.pname}/LICENSE
  '';

  meta = {
    description = "GPU shader wallpapers for Wayland";
    homepage = "https://github.com/1ay1/neowall";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lonerOrz ];
    mainProgram = "neowall";
  };
})
