{ lib, stdenv, fetchurl, makeWrapper, makeDesktopItem, copyDesktopItems, unzip
, appimage-run, nix-update-script }:

stdenv.mkDerivation (finalAttrs: {
  pname = "ldtk";
  version = "1.3.4";

  src = fetchurl {
    url = "https://github.com/deepnight/ldtk/releases/download/v${finalAttrs.version}/ubuntu-distribution.zip";
    hash = "sha256-/EFmuzj8hYhQJegZpZhZb4fuSeMF9wdG1Be4duEvW54=";
  };

  nativeBuildInputs = [ unzip makeWrapper copyDesktopItems appimage-run ];

  buildInputs = [ appimage-run ];

  unpackPhase = ''
    runHook preUnpack

    unzip $src
    appimage-run -x src 'LDtk ${finalAttrs.version} installer.AppImage'

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 'LDtk ${finalAttrs.version} installer.AppImage' $out/share/ldtk.AppImage
    makeWrapper ${appimage-run}/bin/appimage-run $out/bin/ldtk \
      --add-flags $out/share/ldtk.AppImage
    install -Dm644 src/ldtk.png $out/share/icons/hicolor/1024x1024/apps/ldtk.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ldtk";
      exec = "ldtk";
      icon = "ldtk";
      terminal = false;
      desktopName = "LDtk";
      comment = "2D level editor";
      categories = [ "Utility" ];
      mimeTypes = [ "application/json" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Modern, lightweight and efficient 2D level editor";
    homepage = "https://ldtk.io/";
    changelog = "https://github.com/deepnight/ldtk/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ felschr ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
})
