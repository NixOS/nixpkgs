{ lib, stdenv, appimageTools, desktop-file-utils, fetchurl }:

let
  version = "2023.4.113";
  name = "p3x-onenote-${version}";

  plat = {
    aarch64-linux = "-arm64";
    armv7l-linux = "-armv7l";
    i386-linux = "-i386";
    i686-linux = "-i386";
    x86_64-linux = "";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    aarch64-linux = "0a3c0w1312l6k2jvn7cn8priibnh8wg0184zjcli29f9ds1afl5s";
    armv7l-linux = "172m2d94zzm8q61pvnjy01cl5fg11ad9hfh1han0gycnv3difniy";
    i386-linux = "12m0i5sb15sbysp5fvhbj4k36950m7kpjr12n88r5fpkyh13ihsp";
    i686-linux = "12m0i5sb15sbysp5fvhbj4k36950m7kpjr12n88r5fpkyh13ihsp";
    x86_64-linux = "sha256-R52E59kBKwDUb2k1cBhlL2Y3Kwt4i4aMb7kBVUZdcDc=";
  }.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/patrikx3/onenote/releases/download/v${version}/P3X-OneNote-${version}${plat}.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mkdir -p $out/share/pixmaps $out/share/licenses/p3x-onenote
    cp ${appimageContents}/p3x-onenote.png $out/share/pixmaps/
    cp ${appimageContents}/p3x-onenote.desktop $out
    cp ${appimageContents}/LICENSE.electron.txt $out/share/licenses/p3x-onenote/LICENSE
    mv $out/bin/${name} $out/bin/p3x-onenote

    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value $out/bin/p3x-onenote \
      --set-key Comment --set-value "P3X OneNote Linux" \
      --delete-original $out/p3x-onenote.desktop
  '';

  meta = with lib; {
    homepage = "https://github.com/patrikx3/onenote";
    description = "Linux Electron Onenote - A Linux compatible version of OneNote";
    license = licenses.mit;
    maintainers = with maintainers; [ tiagolobocastro ];
    platforms = platforms.linux;
  };
}
