{ lib
, fetchurl
, stdenv
, fetchzip
, ant
, jdk
, makeWrapper
, callPackage
}:

let
  minimalJavaVersion = "11";

  newsPlugin = fetchurl {
    url = "https://www.tvbrowser.org/data/uploads/1372016422809_543/NewsPlugin.jar";
    hash = "sha256-5XoypuMd2AFBE2SJ6EdECuvq6D81HLLuu9UoA9kcKAM=";
  };
in
stdenv.mkDerivation rec {
  pname = "tvbrowser";
  version = "4.2.7";

  src = fetchzip {
    url = "mirror://sourceforge/${pname}/TV-Browser%20Releases%20%28Java%20${minimalJavaVersion}%20and%20higher%29/${version}/${pname}_${version}_src.zip";
    hash = "sha256-dmNfI6T0MU7UtMH+C/2hiAeDwZlFCB4JofQViZezoqI=";
  };

  nativeBuildInputs = [ ant jdk makeWrapper ];

  buildPhase = ''
    runHook preBuild

    ant runtime-linux -Dnewsplugin.url=file://${newsPlugin}
    ant tvbrowser-desktop-entry

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/tvbrowser
    cp -R runtime/tvbrowser_linux/* $out/share/tvbrowser

    mkdir -p $out/share/applications
    mv -t $out/share/applications $out/share/tvbrowser/tvbrowser.desktop
    sed -e 's|=imgs/|='$out'/share/tvbrowser/imgs/|'  \
        -e 's|=tvbrowser.sh|='$out'/bin/tvbrowser|'  \
        -i $out/share/applications/tvbrowser.desktop

    for i in 16 32 48 128; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      ln -s $out/share/tvbrowser/imgs/tvbrowser$i.png  \
          $out/share/icons/hicolor/''${i}x''${i}/apps/tvbrowser.png
    done

    mkdir -p $out/bin
    makeWrapper  \
        $out/share/tvbrowser/tvbrowser.sh  \
        $out/bin/tvbrowser  \
        --prefix PATH : ${jdk}/bin  \
        --prefix XDG_DATA_DIRS : $out/share  \
        --set PROGRAM_DIR $out/share/tvbrowser

    runHook postInstall
  '';

  passthru.tests.startwindow = callPackage ./test.nix {};

  meta = with lib; {
    description = "Electronic TV Program Guide";
    downloadPage = "https://www.tvbrowser.org/index.php?id=tv-browser";
    homepage = "https://www.tvbrowser.org/";
    changelog = "https://www.tvbrowser.org/index.php?id=news";
    sourceProvenance = with sourceTypes; [ binaryBytecode fromSource ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "tvbrowser";
    maintainers = with maintainers; [ jfrankenau yarny ];
    longDescription = ''
      TV-Browser shows TV program data arranged like in printed
      TV programs after downloading it from the internet.
      Plugins are used to download program data
      and to provide additional functionality.
    '';
  };
}
