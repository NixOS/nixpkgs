{ lib, stdenv, appimageTools, desktop-file-utils, fetchurl }:

let
  version = "2022.10.117";
  name = "p3x-onenote-${version}";

  plat = {
    aarch64-linux = "-arm64";
    armv7l-linux = "-armv7l";
    x86_64-linux = "";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    aarch64-linux = "0plpwymm1bgzbzwk2689lw1fadxdwxzzn5dmayk1ayxz1k3pj9wi";
    armv7l-linux = "1pvr8f1ccl4nyfmshn3v3jfaa5x519rsy57g4pdapffj10vpbkb8";
    x86_64-linux = "12j2py8yb81ngahbkbi7269izpc5aydd432cbv0sw45ighhyqhmr";
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
