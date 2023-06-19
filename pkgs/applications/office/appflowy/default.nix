{ stdenv
, lib
, fetchzip
, autoPatchelfHook
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, gtk3
, openssl_1_1
, xdg-user-dirs
, keybinder3
}:

stdenv.mkDerivation rec {
  pname = "appflowy";
  version = "0.2.2";

  src = fetchzip {
    url = "https://github.com/AppFlowy-IO/appflowy/releases/download/${version}/AppFlowy_x86_64-unknown-linux-gnu_ubuntu-20.04.tar.gz";
    sha256 = "sha256-WOq+phZlvmXd/kDchP9RjyCE362hDR20cqNZMxgxVdM=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    openssl_1_1
    keybinder3
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
  };
}
