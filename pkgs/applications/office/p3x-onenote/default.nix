{ lib, stdenv, appimageTools, desktop-file-utils, fetchurl, imagemagick}:

let
  pname = "p3x-onenote";
  version = "2023.10.243";

  plat = {
    aarch64-linux = "-arm64";
    armv7l-linux = "-armv7l";
    x86_64-linux = "";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    aarch64-linux = "sha256-ojd9r6Ax57pEoB7wnhgbCZT5ejRk0nvVDR8sNj36Yjs=";
    armv7l-linux = "1pvr8f1ccl4nyfmshn3v3jfaa5x519rsy57g4pdapffj10vpbkb8";
    x86_64-linux = "sha256-xoBBq+JRUhVfnGJQDolQiZ6YrJpr87Y2EtLo3Lm5CzI=";
  }.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/patrikx3/onenote/releases/download/v${version}/P3X-OneNote-${version}${plat}.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/pixmaps $out/share/licenses/${pname}
    cp ${appimageContents}/${pname}.png $out/share/pixmaps/
    cp ${appimageContents}/LICENSE.electron.txt $out/share/licenses/${pname}/LICENSE
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    for size in 16 32 48 64 72 96 128 192 256 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      ${imagemagick}/bin/convert -resize "$size"x"$size" ${appimageContents}/p3x-onenote.png $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
    done

    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value $out/bin/${pname} \
      --set-key Icon --set-value p3x-onenote \
      --set-key Comment --set-value "${meta.description}" \
       ${appimageContents}/p3x-onenote.desktop
  '';

  meta = with lib; {
    homepage = "https://github.com/patrikx3/onenote";
    description = "Linux Electron Onenote - A Linux compatible version of OneNote";
    license = licenses.mit;
    maintainers = with maintainers; [ tiagolobocastro ];
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
  };
}
