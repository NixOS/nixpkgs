{ stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  gtk3,
  openssl,
  xdg-user-dirs
}:

stdenv.mkDerivation rec {
  pname = "appflowy";
  version = "0.0.2";

  src = fetchzip {
    url = "https://github.com/AppFlowy-IO/appflowy/releases/download/${version}/AppFlowy-linux-x86.tar.gz";
    sha256 = "1fvv4mlgf0vqcq5zh0zl2xr44saz0sm47r8whcywwrmcm0l66iv6";
  };

  nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      copyDesktopItems
  ];

  buildInputs = [
      gtk3
      openssl
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/
    mkdir -p $out/bin/

    # Copy archive contents to the outpout directory
    cp -r ./* $out/opt/

    runHook postInstall
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      xdg-user-dirs
    ];
  in ''
    # Add missing libraries to appflowy using the ones it comes with
    makeWrapper $out/opt/app_flowy $out/bin/appflowy \
          --set LD_LIBRARY_PATH "$out/opt/lib/:${libPath}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "AppFlowy";
      comment = meta.description;
      exec = "appflowy";
      categories = "Office;";
    })
  ];

  meta = with lib; {
    description = "An open-source alternative to Notion";
    homepage = "https://www.appflowy.io/";
    license = licenses.agpl3Only;
    changelog = "https://github.com/AppFlowy-IO/appflowy/releases/tag/${version}";
    maintainers = with maintainers; [ darkonion0 ];
    platforms = [ "x86_64-linux" ];
  };
}
