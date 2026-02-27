{
  stdenv,
  lib,
  maven,
  fetchzip,
  jre,
  writeScript,
  runCommandLocal,
  bash,
  unzip,
  makeWrapper,
  libredirect,
  xsettingsd,
  makeDesktopItem,
  copyDesktopItems,
  python3,
}:
let
  # Run update.py to update this file.
  inherit (lib.importJSON ./version.json) version url sha256;

  src = fetchzip {
    inherit url sha256;
    extension = "zip";
    stripRoot = false;
  };

  # ÁNYK uses some SOAP stuff that's not shipped with OpenJDK any more.
  # We don't really want to use openjdk8 because it's unusable on HiDPI
  # and people are more likely to have a modern OpenJDK installed.
  # We use Maven to resolve these unbundled dependencies.
  # jdk_headless is just overriden so we don't have to fetch another OpenJDK for no reason.
  soapDeps = (maven.override { jdk_headless = jre; }).buildMavenPackage {
    pname = "anyk-soap-deps";
    version = "1.0.0";

    src = lib.sources.sourceFilesBySuffices ./. [ "pom.xml" ];

    mvnHash = "sha256-4keHPzS8pbIIwODmBUMofJt27n5WqYh+IGqE6d9od7k=";

    installPhase = ''
      mkdir -p $out/share/java
      cp target/lib/*.jar $out/share/java/
    '';
  };

  # Binary patch ÁNYK so it works with the JARs we fetch above (removing .internal. from some package names).
  anykSoapPatch =
    runCommandLocal "anyk-patch"
      {
        nativeBuildInputs = [ unzip ];
      }
      ''
        mkdir $out
        cd $out
        unzip ${src}/application/abevjava.jar \
          hu/piller/enykp/niszws/ClientStubBuilder.class
        shopt -s globstar; ${python3}/bin/python ${./patch_paths.py} **/*.class
      '';

  # This script can be used to run template installation jars (or use the Szervíz -> Telepítés menu)
  anyk-java = writeScript "anyk-java" ''
    if [ -f ~/.abevjava/abevjavapath.cfg ]
    then
      if ABEVJAVA_PATH_CFG=$(grep abevjava.path ~/.abevjava/abevjavapath.cfg)
      then
        ABEVJAVA_PATH=''${ABEVJAVA_PATH_CFG#abevjava.path = }
        echo "Determined abevjava path as $ABEVJAVA_PATH"
      else
        echo "Could not determine abevjava path from ~/.abevjava/abevjavapath.cfg"
        exit 1
      fi
    else
      ABEVJAVA_PATH=~/abevjava
      mkdir -p ~/.abevjava
      echo "abevjava.path = $ABEVJAVA_PATH" > ~/.abevjava/abevjavapath.cfg
      echo "Initialized abevjava path as $ABEVJAVA_PATH"
    fi

    # Sync help files.
    mkdir -p "$ABEVJAVA_PATH/segitseg/"
    cp -sRf --no-preserve=all @out@/opt/segitseg/. "$ABEVJAVA_PATH/segitseg"

    export LD_PRELOAD=${libredirect}/lib/libredirect.so:$LD_PRELOAD
    # Look for form templates in ABEVJAVA_PATH instead of the install dir.
    export NIX_REDIRECTS=@out@/opt/nyomtatvanyok=$ABEVJAVA_PATH/nyomtatvanyok:@out@/opt/segitseg=$ABEVJAVA_PATH/segitseg:@out@/opt/setenv=$ABEVJAVA_PATH/setenv:/bin/bash=${bash}/bin/bash:$NIX_REDIRECTS
    if WINDOW_SCALING_FACTOR=$(${xsettingsd}/bin/dump_xsettings | awk '/Gdk\/WindowScalingFactor/{print $NF}'  | grep .); then
      # Fix scaling on HiDPI.
      SCALING_PROP="-Dsun.java2d.uiScale=''${WINDOW_SCALING_FACTOR}"
    fi
    # ÁNYK crashes with NullPointerException with the GTK look and feel so use the cross-platform one.
    exec ${jre}/bin/java -Dswing.systemlaf=javax.swing.plaf.metal.MetalLookAndFeel $SCALING_PROP "$@"
  '';
in
stdenv.mkDerivation {
  pname = "anyk";
  inherit version src;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "ÁNYK";
      name = "anyk";
      exec = "anyk";
      icon = "anyk";
      categories = [ "Office" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -r application $out/opt

    mkdir $out/bin
    substituteAll ${anyk-java} $out/bin/anyk-java
    chmod +x $out/bin/anyk-java

    # ÁNYK has some old school dependencies that are no longer bundled with Java, put them on the classpath. The * is resolved by Java at runtime.
    makeWrapper $out/bin/anyk-java $out/bin/anyk --add-flags "-cp '${soapDeps}/share/java/*:${anykSoapPatch}:$out/opt/abevjava.jar' hu.piller.enykp.gui.framework.MainFrame"

    mkdir -p $out/share/applications

    copyDesktopItems

    install -D $out/opt/abevjava.png $out/share/icons/hicolor/32x32/apps/anyk.png
    runHook postInstall
  '';

  meta = {
    description = "Tool for filling forms for the Hungarian government";
    longDescription = ''
      Official tool for filling Hungarian government forms.

      Use `anyk-java` to install form templates/help files like this: `anyk-java -jar NAV_IGAZOL.jar`
    '';
    homepage = "https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/javakitolto";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ chpatrick ];
    platforms = jre.meta.platforms;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "anyk";
  };
}
