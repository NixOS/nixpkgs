{ stdenv
, lib
, fetchurl
, makeWrapper
, autoPatchelfHook
, jdk11
, makeDesktopItem
, copyDesktopItems
, runtimeShell
, unzip
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "fiji";
  version = "20241114-1317";

  src = fetchurl {
    url = "https://downloads.imagej.net/fiji/archive/${version}/fiji-nojre.zip";
    sha256 = "sha256-dNpscgZiiE2cuuo11YLs+mgoBRZ/MpUXDaAX3x+E/w8=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    makeWrapper
    copyDesktopItems
    unzip
  ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

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
      categories = [ "Education" "Science" "ImageProcessing" ];
      startupNotify = true;
      startupWMClass = "fiji-Main";
    })
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,fiji,share/pixmaps}

    cp -R * $out/fiji
    rm -f $out/fiji/jars/imagej-updater-*.jar

    # Don't create a local desktop entry and avoid deprecated garbage
    # collection option
    cat <<EOF > $out/bin/.fiji-launcher-hack
    #!${runtimeShell}
    exec \$($out/fiji/ImageJ-linux64 --default-gc --dry-run "\$@")
    EOF
    chmod +x $out/bin/.fiji-launcher-hack

    makeWrapper $out/bin/.fiji-launcher-hack $out/bin/fiji \
      --prefix PATH : ${lib.makeBinPath [ jdk11 ]} \
      --set JAVA_HOME ${jdk11.home} \
      ''${gappsWrapperArgs[@]}

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
    license = with lib.licenses; [ gpl2Plus gpl3Plus bsd2 publicDomain ];
    maintainers = with maintainers; [ davisrichard437 ];
  };
}
