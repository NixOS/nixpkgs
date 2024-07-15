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

let
  dist = rec {
    x86_64-linux = {
      urlSuffix = "linux-x86_64.tar.gz";
      hash = "sha256-PVlHPjr6aUkTp9x4MVC8cgebmdaUQXX6eV0/LfAmiJc=";
    };
    x86_64-darwin = {
      urlSuffix = "macos-universal.zip";
      hash = "sha256-gx+iMo2611uoR549gpBoHlp2h6zQtugPZnU9qbH6VIQ=";
    };
    aarch64-darwin = x86_64-darwin;
  }."${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  pname = "appflowy";
  version = "0.6.4";

  src = fetchzip {
    url = "https://github.com/AppFlowy-IO/appflowy/releases/download/${version}/AppFlowy-${version}-${dist.urlSuffix}";
    inherit (dist) hash;
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3
    keybinder3
    libnotify
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = lib.optionalString stdenv.isLinux ''
    runHook preInstall

    cd AppFlowy/

    mkdir -p $out/opt/
    mkdir -p $out/bin/

    # Copy archive contents to the outpout directory
    cp -r ./* $out/opt/

    # Copy icon
    install -Dm444 data/flutter_assets/assets/images/flowy_logo.svg $out/share/icons/hicolor/scalable/apps/appflowy.svg

    runHook postInstall
  '' + lib.optionalString stdenv.isDarwin ''
    runHook preInstall

    mkdir -p $out/{Applications,bin}
    cp -r ./AppFlowy.app $out/Applications/

    runHook postInstall
  '';

  preFixup = lib.optionalString stdenv.isLinux ''
    # Add missing libraries to appflowy using the ones it comes with
    makeWrapper $out/opt/AppFlowy $out/bin/appflowy \
      --set LD_LIBRARY_PATH "$out/opt/lib/" \
      --prefix PATH : "${lib.makeBinPath [ xdg-user-dirs ]}"
  '' + lib.optionalString stdenv.isDarwin ''
    makeWrapper $out/Applications/AppFlowy.app/Contents/MacOS/AppFlowy $out/bin/appflowy
  '';

  desktopItems = lib.optionals stdenv.isLinux [
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
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
    mainProgram = "appflowy";
  };
}
