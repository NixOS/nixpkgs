{ stdenv
, lib
, fetchurl
, dpkg
, makeDesktopItem
, copyDesktopItems
, autoPatchelfHook
, sane-backends
, jdk11
}:

let year = "2021";
in stdenv.mkDerivation rec {
  pname = "pdfstudioviewer";
  version = "${year}.1.2";
  autoPatchelfIgnoreMissingDeps = false;
  strictDeps = true;

  src = fetchurl {
    url = "https://download.qoppa.com/${pname}/v${year}/PDFStudioViewer_v${
        builtins.replaceStrings [ "." ] [ "_" ] version
      }_linux64.deb";
    sha256 = "128k3fm8m8zdykx4s30g5m2zl7cgmvs4qinf1w525zh84v56agz6";
  };

  buildInputs = [
    sane-backends
    jdk11
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    copyDesktopItems
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
  dontBuild = true;

  postPatch = ''
    substituteInPlace opt/${pname}${year}/${pname}${year} --replace "# INSTALL4J_JAVA_HOME_OVERRIDE=" "INSTALL4J_JAVA_HOME_OVERRIDE=${jdk11.out}"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share
    mkdir -p $out/share/pixmaps
    cp -r opt/${pname}${year} $out/share/
    rm -rf $out/share/${pname}${year}/jre
    ln -s $out/share/${pname}${year}/.install4j/${pname}${year}.png  $out/share/pixmaps/
    ln -s $out/share/${pname}${year}/${pname}${year} $out/bin/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.qoppa.com/pdfstudio/";
    description = "An easy to use, full-featured PDF editing software";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = pname;
    maintainers = [ maintainers.pwoelfel ];
  };
}
