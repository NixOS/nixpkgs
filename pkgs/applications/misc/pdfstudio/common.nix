{ pname
, src
, year
, version
, desktopName
, longDescription
, buildFHSUserEnv
, extraBuildInputs ? []
, stdenv
, lib
, dpkg
, makeDesktopItem
, copyDesktopItems
, autoPatchelfHook
, sane-backends
, cups
, jdk11
}:
let
  thisPackage = stdenv.mkDerivation rec {
    inherit pname src version;
    strictDeps = true;

    buildInputs = [
      sane-backends #for libsane.so.1
      jdk11
    ] ++ extraBuildInputs;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      copyDesktopItems
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "${pname}${year}";
        desktopName = desktopName;
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

    unpackCmd = "dpkg-deb -x $src ./${pname}-${version}";
    dontBuild = true;

    postPatch = ''
      substituteInPlace opt/${pname}${year}/${pname}${year} --replace "# INSTALL4J_JAVA_HOME_OVERRIDE=" "INSTALL4J_JAVA_HOME_OVERRIDE=${jdk11.out}"
      substituteInPlace opt/${pname}${year}/updater --replace "# INSTALL4J_JAVA_HOME_OVERRIDE=" "INSTALL4J_JAVA_HOME_OVERRIDE=${jdk11.out}"
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share/pixmaps}
      rm -rf opt/${pname}${year}/jre
      cp -r opt/${pname}${year} $out/share/
      ln -s $out/share/${pname}${year}/.install4j/${pname}${year}.png  $out/share/pixmaps/
      ln -s $out/share/${pname}${year}/${pname}${year} $out/bin/${pname}

      runHook postInstall
    '';
  };

in
# Package with cups in FHS sandbox, because JAVA bin expects "/usr/bin/lpr" for printing.
buildFHSUserEnv {
  name = pname;
  targetPkgs = pkgs: [
    cups
    thisPackage
  ];
  runScript = pname;

  # link desktop item and icon into FHS user environment
  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/pixmaps"
    ln -s ${thisPackage}/share/applications/*.desktop "$out/share/applications/"
    ln -s ${thisPackage}/share/pixmaps/*.png "$out/share/pixmaps/"
  '';

  meta = with lib; {
    homepage = "https://www.qoppa.com/${pname}/";
    description = "An easy to use, full-featured PDF editing software";
    longDescription = longDescription;
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = pname;
    maintainers = [ maintainers.pwoelfel ];
  };
}
