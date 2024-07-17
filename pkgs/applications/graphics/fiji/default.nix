{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  jdk11,
  makeDesktopItem,
  copyDesktopItems,
  runtimeShell,
}:
stdenv.mkDerivation rec {
  pname = "fiji";
  version = "20201104-1356";

  src = fetchurl {
    url = "https://downloads.imagej.net/${pname}/archive/${version}/${pname}-nojre.tar.gz";
    sha256 = "1jv4wjjkpid5spr2nk5xlvq3hg687qx1n5zh8zlw48y1y09c4q7a";
  };

  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];
  buildInputs = [ stdenv.cc.cc.lib ];

  desktopItems = [
    (makeDesktopItem {
      name = "fiji";
      exec = "fiji %F";
      tryExec = "fiji";
      icon = "fiji";
      mimeTypes = [ "image/*" ];
      comment = "Scientific Image Analysis";
      desktopName = "Fiji Is Just ImageJ";
      genericName = "Fiji Is Just ImageJ";
      categories = [
        "Education"
        "Science"
        "ImageProcessing"
      ];
      startupNotify = true;
      startupWMClass = "fiji-Main";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,fiji,share/pixmaps}

    cp -R * $out/fiji
    rm -f $out/fiji/jars/imagej-updater-*.jar

    # Disgusting hack to stop a local desktop entry being created
    cat <<EOF > $out/bin/.fiji-launcher-hack
    #!${runtimeShell}
    exec \$($out/fiji/ImageJ-linux64 --dry-run "\$@")
    EOF
    chmod +x $out/bin/.fiji-launcher-hack

    makeWrapper $out/bin/.fiji-launcher-hack $out/bin/fiji \
      --prefix PATH : ${lib.makeBinPath [ jdk11 ]} \
      --set JAVA_HOME ${jdk11.home}

    ln $out/fiji/images/icon.png $out/share/pixmaps/fiji.png

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://imagej.net/software/fiji/";
    description = "batteries-included distribution of ImageJ2, bundling a lot of plugins which facilitate scientific image analysis";
    mainProgram = "fiji";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = with lib.licenses; [
      gpl2Plus
      gpl3Plus
      bsd2
      publicDomain
    ];
    maintainers = with maintainers; [ ];
  };
}
