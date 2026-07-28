{
  stdenv,
  fetchFromGitHub,
  lib,
  pkg-config,
  libxt,
  libxrandr,
  libxi,
  libxinerama,
  libxfixes,
  libxext,
  libx11,
  xorgproto,
  cairo,
  pango,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libconfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "activate-linux";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "MrGlockenspiel";
    repo = "activate-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zTZZb4zFbhwZPN1B2c6ZIfiJOGxjXxxIXBBAteIWt1Q=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cairo
    pango
    libx11
    libxext
    libxfixes
    libxi
    libxinerama
    libxrandr
    libxt
    xorgproto
    wayland
    wayland-protocols
    libconfig
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/man/man1

    cp activate-linux $out/bin
    cp activate-linux.1 $out/share/man/man1

    install -Dm444 res/activate-linux.png $out/share/icons/hicolor/128x128/apps/activate-linux.png
    install -Dm444 res/activate-linux.desktop -t $out/share/applications

    runHook postInstall
  '';

  meta = {
    description = "\"Activate Windows\" watermark ported to Linux";
    homepage = "https://github.com/MrGlockenspiel/activate-linux";
    changelog = "https://github.com/MrGlockenspiel/activate-linux/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      alexnortung
      donovanglover
    ];
    platforms = lib.platforms.linux;
    mainProgram = "activate-linux";
  };
})
