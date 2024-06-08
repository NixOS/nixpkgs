{ alsa-lib
, at-spi2-atk
, autoPatchelfHook
, cairo
, cups
, dbus
, desktop-file-utils
, expat
, fetchurl
, gdk-pixbuf
, gtk3
, gvfs
, hicolor-icon-theme
, lib
, libdrm
, libglvnd
, libnotify
, libsForQt5
, libxkbcommon
, mesa
, nspr
, nss
, openssl
, pango
, rpmextract
, stdenv
, systemd
, trash-cli
, vulkan-loader
, wrapGAppsHook3
, xdg-utils
, xorg
}:
stdenv.mkDerivation rec  {
  pname = "plasticity";
  version = "24.1.5";

  src = fetchurl {
    url = "https://github.com/nkallen/plasticity/releases/download/v${version}/Plasticity-${version}-1.x86_64.rpm";
    hash = "sha256-1oneFWWgMYsh12knn+Atp8ttSnTdaV+5TWwp2htZsvE=";
  };

  passthru.updateScript = ./update.sh;

  nativeBuildInputs = [ wrapGAppsHook3 autoPatchelfHook rpmextract mesa ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    desktop-file-utils
    expat
    gdk-pixbuf
    gtk3
    gvfs
    hicolor-icon-theme
    libdrm
    libnotify
    libsForQt5.kde-cli-tools
    libxkbcommon
    nspr
    nss
    openssl
    pango
    stdenv.cc.cc.lib
    trash-cli
    xdg-utils
  ];

  runtimeDependencies = [
    systemd
    libglvnd
    vulkan-loader #may help with nvidia users
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXtst
  ];

  dontUnpack = true;

  # can't find anything on the internet about these files, no clue what they do
  autoPatchelfIgnoreMissingDeps = [
    "ACCAMERA.tx"
    "AcMPolygonObj15.tx"
    "ATEXT.tx"
    "ISM.tx"
    "RText.tx"
    "SCENEOE.tx"
    "TD_DbEntities.tx"
    "TD_DbIO.tx"
    "WipeOut.tx"
   ];

installPhase = ''
  runHook preInstall

  mkdir $out
  cd $out
  rpmextract $src
  mv $out/usr/* $out
  rm -r $out/usr

  runHook postInstall
'';

  #--use-gl=egl for it to use hardware rendering it seems. Otherwise there are terrible framerates
  postInstall = ''
    substituteInPlace share/applications/Plasticity.desktop \
      --replace-fail 'Exec=Plasticity %U' "Exec=Plasticity --use-gl=egl %U"
  '';

  meta = with lib; {
    description = "CAD for artists";
    homepage = "https://www.plasticity.xyz";
    license = licenses.unfree;
    mainProgram = "Plasticity";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ imadnyc ];
    platforms = [ "x86_64-linux" ];
  };
}
