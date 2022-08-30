{ lib, stdenvNoCC, appimageTools, desktop-file-utils, fetchurl }:

let
  version = "2022.4.127";
  name = "p3x-onenote-${version}";

  plat = {
    aarch64-linux = "-arm64";
    armv7l-linux = "-armv7l";
    x86_64-linux = "";
  }.${stdenvNoCC.hostPlatform.system};

  sha256 = {
    aarch64-linux = "09sahxil3lcrr40l1fawglmafl643f5anyi9rlhgi2461yghm4qj";
    armv7l-linux = "14kf455z8705k7ixys4b6rsf1jzsyws6b3gll0bi2ziig0drzzxl";
    x86_64-linux = "05zr0b06qrlg0kbg58l7wn4jn79jcmzxysm6m30qfmkzliyc33sr";
  }.${stdenvNoCC.hostPlatform.system};

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
    platforms = [ "aarch64-linux" "armv7l-linux" "x86_64-linux" ];
  };
}
