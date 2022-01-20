{ stdenv, lib, fetchurl, dpkg, makeDesktopItem, copyDesktopItems
, autoPatchelfHook, makeWrapper, sane-backends, xorg, jdk11, gtk2, gtk3 }:

let year = "2021";
in stdenv.mkDerivation rec {
  pname = "pdfstudioviewer";
  version = "${year}.1.2";
  autoPatchelfIgnoreMissingDeps = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://download.qoppa.com/${pname}/v${year}/PDFStudioViewer_v${
        builtins.replaceStrings [ "." ] [ "_" ] version
      }_linux64.deb";
    sha256 = "128k3fm8m8zdykx4s30g5m2zl7cgmvs4qinf1w525zh84v56agz6";
  };

  buildInputs =
    [ xorg.libXrandr xorg.libXtst sane-backends xorg.libXxf86vm gtk2 gtk3 ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    copyDesktopItems
    jdk11 # for unpacking .jar.pack files
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "${pname}${year}";
      desktopName = "PDF Studio";
      genericName = "View and edit PDF files";
      exec = "${pname} %f";
      icon = "${pname}${year}";
      comment = "Views and edits PDF files";
      mimeType = "application/pdf";
      categories = "Office";
      type = "Application";
      terminal = false;
    })
  ];

  unpackPhase = "dpkg-deb -x $src .";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share
    mkdir -p $out/share/pixmaps
    cp -r opt/${pname}${year} $out/share/
    ln -s $out/share/${pname}${year}/.install4j/${pname}${year}.png  $out/share/pixmaps/
    ln -s $out/share/${pname}${year}/${pname}${year} $out/bin/${pname}

    #Unpack jar files. Otherwise pdfstudio does this and fails due to read-only FS.
    for pfile in $out/share/${pname}${year}/jre/lib/{,ext/}*.jar.pack; do
      jar_file=`echo "$pfile" | awk '{ print substr($0,1,length($0)-5) }'`
      unpack200 -r "$pfile" "$jar_file"
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.qoppa.com/pdfstudio/";
    description = "An easy to use, full-featured PDF editing software";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainprogram = pname;
    maintainers = [ maintainers.pwoelfel ];
  };
}
