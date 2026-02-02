{
  lib,
  stdenv,
  appimageTools,
  desktop-file-utils,
  fetchurl,
}:

let
  pname = "p3x-onenote";
  version = "2025.10.111";

  plat =
    {
      aarch64-linux = "-arm64";
      armv7l-linux = "-armv7l";
      x86_64-linux = "";
    }
    .${stdenv.hostPlatform.system};

  hash =
    {
      aarch64-linux = "sha256-sfnRzY+1flUdIM1ey9u00j9eiDa4u5bY/f3fupV+FKM=";
      armv7l-linux = "sha256-ZnFSJE1VmvqSKZHBsMtvBbypsbY35z9X5T4bYT0DytU=";
      x86_64-linux = "sha256-lgZjVVBWPloqMWX0oryNB0lxgmJCBqC7pp0AjeUMjQM=";
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

  meta = {
    homepage = "https://github.com/patrikx3/onenote";
    description = "Linux Electron Onenote - A Linux compatible version of OneNote";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tiagolobocastro ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
    mainProgram = "p3x-onenote";
  };
}
