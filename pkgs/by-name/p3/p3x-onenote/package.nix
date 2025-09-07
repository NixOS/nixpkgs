{
  lib,
  stdenv,
  appimageTools,
  desktop-file-utils,
  fetchurl,
}:

let
  pname = "p3x-onenote";
  version = "2025.10.101";

  plat =
    {
      aarch64-linux = "-arm64";
      armv7l-linux = "-armv7l";
      x86_64-linux = "";
    }
    .${stdenv.hostPlatform.system};

  hash =
    {
      aarch64-linux = "sha256-FB6+0Ze3d/6QETgtMtc6GztnPdSy5s7k67qsAtFdsyM=";
      armv7l-linux = "sha256-Q45tfcGrNjd9wXt+VhXhaHrC4w68lRUIuB4cJSW5NDE=";
      x86_64-linux = "sha256-h2U9EctjyM4FlVe/pPMWugCIe9tQ4Av4/HOcWWSUNEI=";
    }
    .${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/patrikx3/onenote/releases/download/v${version}/P3X-OneNote-${version}${plat}.AppImage";
    inherit hash;
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/pixmaps $out/share/licenses/p3x-onenote
    cp ${appimageContents}/p3x-onenote.png $out/share/pixmaps/
    cp ${appimageContents}/p3x-onenote.desktop $out
    cp ${appimageContents}/LICENSE.electron.txt $out/share/licenses/p3x-onenote/LICENSE

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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
    mainProgram = "p3x-onenote";
  };
}
