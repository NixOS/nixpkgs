{ stdenv
, lib
, fetchzip
, autoPatchelfHook
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, gtk3
, xdg-user-dirs
, keybinder3
, libnotify
}:

stdenv.mkDerivation rec {
  pname = "appflowy";
  version = "0.5.7";

  src = fetchzip {
    url = "https://github.com/AppFlowy-IO/appflowy/releases/download/${version}/AppFlowy-${version}-linux-x86_64.tar.gz";
    hash = "sha256-SVtAx/yllHugBys506pT/5n6IDEZvPEeCHRjFHLMZ0A=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    keybinder3
    libnotify
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    cd AppFlowy/

    mkdir -p $out/opt/
    mkdir -p $out/bin/

    # Copy archive contents to the outpout directory
    cp -r ./* $out/opt/

    # Copy icon
    install -Dm444 data/flutter_assets/assets/images/flowy_logo.svg $out/share/icons/hicolor/scalable/apps/appflowy.svg

    runHook postInstall
  '';

  preFixup = ''
    # Add missing libraries to appflowy using the ones it comes with
    makeWrapper $out/opt/AppFlowy $out/bin/appflowy \
      --set LD_LIBRARY_PATH "$out/opt/lib/" \
      --prefix PATH : "${lib.makeBinPath [ xdg-user-dirs ]}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "AppFlowy";
      comment = meta.description;
      exec = "appflowy";
      icon = "appflowy";
      categories = [ "Office" ];
    })
  ];

  meta = with lib; {
    description = "An open-source alternative to Notion";
    homepage = "https://www.appflowy.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.agpl3Only;
    changelog = "https://github.com/AppFlowy-IO/appflowy/releases/tag/${version}";
    maintainers = with maintainers; [ darkonion0 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "appflowy";
  };
}
