{ lib
, stdenv
, fetchurl
, dpkg
, imagemagick
, copyDesktopItems
, makeDesktopItem
, autoPatchelfHook
, wrapGAppsHook
, icu
, openssl
, xorg
}:

let
  version = "2.8.6";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/BeyondDimension/SteamTools/releases/download/${version}/Steam++_linux_x64_v${version}.deb";
      sha256 = "183393l89s1il6ihyhwn3aai13yvgdi6831c09zmpvlcbaks0l9d";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/BeyondDimension/SteamTools/releases/download/${version}/Steam++_linux_arm64_v${version}.deb";
      sha256 = "1k3j9kr6mkrni7cbszb5sx4bj25ajdqsjlcrz4hm9kd3fc054zgf";
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "watt-toolkit";
  inherit version src;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook
    imagemagick
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "watt-toolkit";
      exec = "watt-toolkit";
      icon = "watt-toolkit";
      comment = meta.description;
      desktopName = "Watt Toolkit";
      categories = [ "Utility" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin $out/share/icons/hicolor/256x256/apps
    cp -r usr/share/Steam++ $out/opt/watt-toolkit
    magick usr/share/Steam++/Steam++.ico watt-toolkit.png
    install -Dm644 watt-toolkit-0.png $out/share/icons/hicolor/256x256/apps/watt-toolkit.png
    ln -sf $out/opt/watt-toolkit/Steam++ $out/bin/watt-toolkit

    runHook postInstall
  '';

  preFixup =
    let
      libpath = lib.makeLibraryPath
        ([
          icu
          openssl
          xorg.libX11
          xorg.libICE
          xorg.libSM
        ]);
    in
    ''
      gappsWrapperArgs+=(
        --set LD_LIBRARY_PATH ${libpath}
      )
    '';

  meta = with lib; {
    homepage = "https://steampp.net";
    description = "A cross-platform Steam toolbox";
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ rs0vere ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
