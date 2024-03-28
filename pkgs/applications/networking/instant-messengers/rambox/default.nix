{ lib
, stdenv
, appimageTools
, fetchurl
, makeWrapper
, makeDesktopItem
, alsa-utils
, electron
, libappindicator-gtk3
, libdrm
, libpulseaudio
, pipewire
}:

stdenv.mkDerivation rec {
  pname = "rambox";
  version = "2.3.1";

  src = fetchurl {
    url = "https://github.com/ramboxapp/download/releases/download/v${version}/Rambox-${version}-linux-x64.AppImage";
    hash = "sha256-fSj/AX1uCUAC3Vg5+rtGF3IDPFTHRAgJ8CPVL8BYc+E=";
  };

  desktopItem = (makeDesktopItem {
    desktopName = "Rambox";
    name = pname;
    exec = "rambox";
    icon = pname;
    categories = [ "Network" ];
  });

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share
    cp -a ${appimageContents}/rambox.desktop $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
       ${lib.optionalString stdenv.isLinux ''
        --prefix PATH : ${lib.makeBinPath [ alsa-utils ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc libappindicator-gtk3 libdrm libpulseaudio pipewire ]} \
      ''} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  extraPkgs = pkgs: with pkgs; [ procps ];

  meta = with lib; {
    description = "Workspace Simplifier - a cross-platform application organizing web services into Workspaces similar to browser profiles";
    homepage = "https://rambox.app";
    license = licenses.unfree;
    maintainers = with maintainers; [ nazarewk ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
