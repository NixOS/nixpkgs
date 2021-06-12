{ makeDesktopItem
, copyDesktopItems
, lib
, stdenv
, fetchurl
, fontconfig
, freetype
, libxcb
, libxkbcommon
, xorg
}:

let
  rpath = lib.makeLibraryPath [
    fontconfig
    freetype
    libxcb
    libxkbcommon
    stdenv.cc.cc.lib
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    xorg.libX11
    xorg.libXext
  ];

in stdenv.mkDerivation rec {
  pname = "ricochet-refresh";
  version = "3.0.10";

  # stripping breaks if rpath is set to a longer value using patchelf prior
  # see: https://github.com/NixOS/patchelf/issues/10
  dontStrip = true;

  src = fetchurl {
    url = "https://github.com/blueprint-freespeech/ricochet-refresh/releases/download/v${version}-release/ricochet-refresh-${version}-linux-x86_64.tar.gz";
    sha256 = "32eca517e0d20e5b427c6d9beafa4f18373b7417907c89e01beebe3934caf32e";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "ricochet-refresh";
      exec = "ricochet-refresh";
      icon = "ricochet-refresh";
      desktopName = "Ricochet Refresh";
      genericName = "Ricochet Refresh";
      categories = "Network;InstantMessaging;";
    })
  ];
  nativeBuildInputs = [ copyDesktopItems ];

  unpackPhase = ''
    echo "unpacking $src..."
    tar -xvf $src
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pixmaps
    mv ricochet-refresh/ricochet-refresh.png $out/share/pixmaps/ricochet-refresh.png
    mv ricochet-refresh $out/bin

    pushd $out/bin
    for file in ricochet-refresh tor; do
      patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} --set-rpath ${rpath} $file
    done
    popd

    runHook postInstall
  '';

  meta = with lib; {
    description = "Private, anonymous, and metadata resistant instant messaging using Tor onion services";
    homepage = "https://www.ricochetrefresh.net";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = teams.blueprint-freespeech.members;
  };
}
