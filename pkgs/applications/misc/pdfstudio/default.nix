{ stdenv
, lib
, fetchurl
, libgccjit
, dpkg
, makeDesktopItem
, copyDesktopItems
, autoPatchelfHook
, sane-backends
, jdk11
}:

# See also package 'pdfstudioviewer'
# Differences are ${pname}, Download directory name (PDFStudio / PDFStudioViewer),
# sha256, and libgccjit (not needed for PDFStudioViewer)
let year = "2021";
in
stdenv.mkDerivation rec {
  pname = "pdfstudio";
  version = "${year}.1.2";
  strictDeps = true;

  src = fetchurl {
    url = "https://download.qoppa.com/${pname}/v${year}/PDFStudio_v${
        builtins.replaceStrings [ "." ] [ "_" ] version
      }_linux64.deb";
    sha256 = "1188ll2qz58rr2slavqxisbz4q3fdzidpasb1p33926z0ym3rk45";
  };

  buildInputs = [
    libgccjit #for libstdc++.so.6 and libgomp.so.1
    sane-backends #for libsane.so.1
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
    substituteInPlace opt/${pname}${year}/updater --replace "# INSTALL4J_JAVA_HOME_OVERRIDE=" "INSTALL4J_JAVA_HOME_OVERRIDE=${jdk11.out}"
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
