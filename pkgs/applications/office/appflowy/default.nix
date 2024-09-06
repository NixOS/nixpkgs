{
  stdenvNoCC,
  lib,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  gtk3,
  xdg-user-dirs,
  keybinder3,
  libnotify,
}:

let
  dist =
    rec {
      x86_64-linux = {
        urlSuffix = "linux-x86_64.tar.gz";
        hash = "sha256-sQ3dxwPWHLUoWgnR9+oHaFoDzXxtwKRiBvz2wkFB01g=";
      };
      x86_64-darwin = {
        urlSuffix = "macos-universal.zip";
        hash = "sha256-4bU/qecZBrTr34SZAjDDgwpXAAHDITz6lV6mJGjElko=";
      };
      aarch64-darwin = x86_64-darwin;
    }
    ."${stdenvNoCC.hostPlatform.system}";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "appflowy";
  version = "0.6.8";

  src = fetchzip {
    url = "https://github.com/AppFlowy-IO/appflowy/releases/download/${finalAttrs.version}/AppFlowy-${finalAttrs.version}-${dist.urlSuffix}";
    inherit (dist) hash;
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ] ++ lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];

  buildInputs = [
    gtk3
    keybinder3
    libnotify
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase =
    lib.optionalString stdenvNoCC.isLinux ''
      runHook preInstall

      cd AppFlowy/

      mkdir -p $out/{bin,opt}

      # Copy archive contents to the outpout directory
      cp -r ./* $out/opt/

      # Copy icon
      install -Dm444 data/flutter_assets/assets/images/flowy_logo.svg $out/share/icons/hicolor/scalable/apps/appflowy.svg

      runHook postInstall
    ''
    + lib.optionalString stdenvNoCC.isDarwin ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}
      cp -r ./AppFlowy.app $out/Applications/

      runHook postInstall
    '';

  preFixup =
    lib.optionalString stdenvNoCC.isLinux ''
      # Add missing libraries to appflowy using the ones it comes with
      makeWrapper $out/opt/AppFlowy $out/bin/appflowy \
        --set LD_LIBRARY_PATH "$out/opt/lib/" \
        --prefix PATH : "${lib.makeBinPath [ xdg-user-dirs ]}"
    ''
    + lib.optionalString stdenvNoCC.isDarwin ''
      makeWrapper $out/Applications/AppFlowy.app/Contents/MacOS/AppFlowy $out/bin/appflowy
    '';

  desktopItems = lib.optionals stdenvNoCC.isLinux [
    (makeDesktopItem {
      name = "appflowy";
      desktopName = "AppFlowy";
      comment = finalAttrs.meta.description;
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
    changelog = "https://github.com/AppFlowy-IO/appflowy/releases/tag/${finalAttrs.version}";
    maintainers = with maintainers; [ darkonion0 ];
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
    mainProgram = "appflowy";
  };
})
