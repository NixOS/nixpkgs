{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, SDL2
, alsa-lib
, ffmpeg
, lua5_3
, qt5
, file
, makeDesktopItem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtas";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "clementgallet";
    repo = "libTAS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-n4iaJG9k+/TFfGMDCYL83Z6paxpm/gY3thP9T84GeQU=";
  };

  nativeBuildInputs = [ autoreconfHook qt5.wrapQtAppsHook pkg-config ];
  buildInputs = [ SDL2 alsa-lib ffmpeg lua5_3 qt5.qtbase ];

  configureFlags = [
    "--enable-release-build"
  ];

  postInstall = ''
    mkdir -p $out/lib
    mv $out/bin/libtas*.so $out/lib/
  '';

  enableParallelBuilding = true;

  postFixup = ''
    wrapProgram $out/bin/libTAS \
      --suffix PATH : ${lib.makeBinPath [ file ]} \
      --set-default LIBTAS_SO_PATH $out/lib/libtas.so
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "libTAS";
      desktopName = "libTAS";
      exec = "libTAS %U";
      icon = "libTAS";
      startupWMClass = "libTAS";
      keywords = [ "libTAS" ];
    })
  ];

  meta = with lib; {
    homepage = "https://clementgallet.github.io/libTAS/";
    description = "GNU/Linux software to give TAS tools to games";
    license = lib.licenses.gpl3Only;
    maintainers = with maintainers; [ skyrina ];
    mainProgram = "libTAS";
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
})
