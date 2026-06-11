{
  lib,
  stdenv,
  appimageTools,
  desktop-file-utils,
  fetchurl,
}:

let
  pname = "p3x-onenote";
  onenote = lib.importJSON ./sources.json;

  version = onenote.version;

  plat =
    {
      aarch64-linux = "-arm64";
      x86_64-linux = "";
    }
    .${stdenv.hostPlatform.system};

  hash = onenote.hash.${stdenv.hostPlatform.system};

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
    mkdir -p $out/share/licenses/p3x-onenote
    install -D ${appimageContents}/p3x-onenote.png -t $out/share/icons/hicolor/512x512/apps/
    cp ${appimageContents}/p3x-onenote.desktop $out
    cp ${appimageContents}/LICENSE.electron.txt $out/share/licenses/p3x-onenote/LICENSE

    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Comment --set-value "P3X OneNote Linux" \
      --set-key Exec --set-value "p3x-onenote" \
      --delete-original $out/p3x-onenote.desktop
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/patrikx3/onenote";
    description = "Linux Electron Onenote - A Linux compatible version of OneNote";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tiagolobocastro ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "p3x-onenote";
  };
}
