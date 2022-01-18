{ stdenv,
  lib,
  makeWrapper,
  fetchurl,
  dpkg,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  gst_all_1,
  sane-backends,
  xorg,
  gnome2,
  alsa-lib,
  libgccjit,
  jdk11
  }:

let
  year = "2021";
  major = "1";
  minor = "2";
in stdenv.mkDerivation rec {
  pname = "pdfstudioviewer";
  version = "${year}.1.2";
  autoPatchelfIgnoreMissingDeps = true;

  src = fetchurl {
    url = "https://download.qoppa.com/${pname}/v${year}/PDFStudioViewer_v${builtins.replaceStrings ["."] ["_"] version}_linux64.deb";
    sha256 = "128k3fm8m8zdykx4s30g5m2zl7cgmvs4qinf1w525zh84v56agz6";
  };

  nativeBuildInputs = [
    gst_all_1.gst-libav
    sane-backends
    xorg.libXxf86vm
    xorg.libXtst
    gnome2.libgtkhtml
    alsa-lib
    libgccjit
    autoPatchelfHook
    makeWrapper
    dpkg
    copyDesktopItems
    jdk11 # only for unpacking .jar.pack files
  ];

  desktopItems = [(makeDesktopItem {
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
  })];

  unpackPhase = "dpkg-deb -x $src .";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    cp -r opt/${pname}${year} $out/share/
    ln -s $out/share/${pname}${year}/.install4j/${pname}${year}.png  $out/share/pixmaps/
    makeWrapper $out/share/${pname}${year}/${pname}${year} $out/bin/${pname}

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
    maintainers = [ maintainers.pwoelfel ];
  };
}
