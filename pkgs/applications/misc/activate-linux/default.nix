{ stdenv
, fetchFromGitHub
, lib
, pkg-config
, xorg
, cairo
, wayland
, wayland-protocols
, wayland-scanner
, libconfig
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "activate-linux";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "MrGlockenspiel";
    repo = "activate-linux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6XnoAoZwAs2hKToWlDqkaGqucmV1VMkEc4QO0G0xmrg=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cairo
    xorg.libX11
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXt
    xorg.xorgproto
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

    install -Dm444 res/icon.png $out/share/icons/hicolor/128x128/apps/activate-linux.png
    install -Dm444 res/activate-linux.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/activate-linux.desktop \
      --replace 'Icon=icon' 'Icon=activate-linux'

    runHook postInstall
  '';

  meta = with lib; {
    description = "The \"Activate Windows\" watermark ported to Linux";
    homepage = "https://github.com/MrGlockenspiel/activate-linux";
    license = licenses.gpl3;
    maintainers = with maintainers; [ alexnortung donovanglover ];
    platforms = platforms.linux;
    mainProgram = "activate-linux";
  };
})
