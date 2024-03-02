{ pname
, program
, src
, year
, version
, desktopName
, longDescription
, broken ? false
, buildFHSEnv
, extraBuildInputs ? [ ]
, jdk
, stdenv
, lib
, dpkg
, makeDesktopItem
, copyDesktopItems
, autoPatchelfHook
, sane-backends
, cups
}:
let
  thisPackage = stdenv.mkDerivation rec {
    inherit pname src version;
    strictDeps = true;

    buildInputs = [
      sane-backends #for libsane.so.1
    ] ++ extraBuildInputs;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      copyDesktopItems
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "${pname}";
        desktopName = desktopName;
        genericName = "View and edit PDF files";
        exec = "${pname} %f";
        icon = "${pname}";
        comment = "Views and edits PDF files";
        mimeTypes = [ "application/pdf" ];
        categories = [ "Office" ];
      })
    ];

    unpackCmd = "dpkg-deb -x $src ./${program}-${version}";
    dontBuild = true;

    postPatch = ''
      substituteInPlace opt/${program}${year}/${program}${year} --replace "# INSTALL4J_JAVA_HOME_OVERRIDE=" "INSTALL4J_JAVA_HOME_OVERRIDE=${jdk.out}"
      substituteInPlace opt/${program}${year}/updater --replace "# INSTALL4J_JAVA_HOME_OVERRIDE=" "INSTALL4J_JAVA_HOME_OVERRIDE=${jdk.out}"
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share/pixmaps}
      rm -rf opt/${program}${year}/jre
      cp -r opt/${program}${year} $out/share/
      ln -s $out/share/${program}${year}/.install4j/${program}${year}.png  $out/share/pixmaps/${pname}.png
      ln -s $out/share/${program}${year}/${program}${year} $out/bin/

      runHook postInstall
    '';
  };

in
# Package with cups in FHS sandbox, because JAVA bin expects "/usr/bin/lpr" for printing.
buildFHSEnv {
  name = pname;
  targetPkgs = pkgs: [
    cups
    thisPackage
  ];
  runScript = "${program}${year}";

  # link desktop item and icon into FHS user environment
  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/pixmaps"
    ln -s ${thisPackage}/share/applications/*.desktop "$out/share/applications/"
    ln -s ${thisPackage}/share/pixmaps/*.png "$out/share/pixmaps/"
  '';

  meta = with lib; {
    inherit broken;
    homepage = "https://www.qoppa.com/${pname}/";
    description = "An easy to use, full-featured PDF editing software";
    longDescription = longDescription;
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = pname;
    maintainers = [ maintainers.pwoelfel ];
  };
}
