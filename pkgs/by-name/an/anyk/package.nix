{
  stdenv,
  lib,
<<<<<<< HEAD
  maven,
  fetchzip,
  jre,
=======
  fetchurl,
  fetchzip,
  openjdk,
  openjfx,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
  # ÁNYK needs JavaFX for the Ügyfélkapu login webview.
  jdkWithFX = openjdk.override {
    enableJavaFX = true;
    openjfx_jdk = openjfx.override { withWebKit = true; };
  };

  extraClasspath = [
    # ÁNYK uses some SOAP stuff that's not shipped with OpenJDK any more.
    # We don't really want to use openjdk8 because it's unusable on HiDPI
    # and people are more likely to have a modern OpenJDK installed.
    (fetchurl {
      url = "mirror://maven/org/glassfish/metro/webservices-rt/2.4.10/webservices-rt-2.4.10.jar";
      hash = "sha256-lHclIZn3HR2B2lMttmmQGIV67qJi5KhL5jT2WNUQpPI=";
    })

    (fetchurl {
      url = "mirror://maven/org/glassfish/metro/webservices-api/2.4.10/webservices-api-2.4.10.jar";
      hash = "sha256-1jiabjPkRnh+l/fmTt8aKE5hpeLreYOiLH9sVIcLUQE=";
    })

    (fetchurl {
      url = "mirror://maven/com/sun/activation/jakarta.activation/2.0.1/jakarta.activation-2.0.1.jar";
      hash = "sha256-ueJLfdbgdJVWLqllMb4xMMltuk144d/Yitu96/QzKHE=";
    })

    # Patch one of the ÁNYK classes so it works with the packages above by removing .internal. from the package names.
    (runCommandLocal "anyk-patch" { } ''
      mkdir $out
      cd $out
      ${unzip}/bin/unzip ${src}/application/abevjava.jar hu/piller/enykp/niszws/ClientStubBuilder.class
      ${python3}/bin/python ${./patch_paths.py} hu/piller/enykp/niszws/ClientStubBuilder.class
    '')
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    exec ${jre}/bin/java -Dswing.systemlaf=javax.swing.plaf.metal.MetalLookAndFeel $SCALING_PROP "$@"
=======
    exec ${jdkWithFX}/bin/java -Dswing.systemlaf=javax.swing.plaf.metal.MetalLookAndFeel $SCALING_PROP "$@"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    mkdir $out
    cp -r application $out/opt

    mkdir $out/bin
    substituteAll ${anyk-java} $out/bin/anyk-java
    chmod +x $out/bin/anyk-java

<<<<<<< HEAD
    # ÁNYK has some old school dependencies that are no longer bundled with Java, put them on the classpath. The * is resolved by Java at runtime.
    makeWrapper $out/bin/anyk-java $out/bin/anyk --add-flags "-cp '${soapDeps}/share/java/*:${anykSoapPatch}:$out/opt/abevjava.jar' hu.piller.enykp.gui.framework.MainFrame"
=======
    # ÁNYK has some old school dependencies that are no longer bundled with Java, put them on the classpath.
    makeWrapper $out/bin/anyk-java $out/bin/anyk --add-flags "-cp ${lib.concatStringsSep ":" extraClasspath}:$out/opt/abevjava.jar hu.piller.enykp.gui.framework.MainFrame"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    mkdir -p $out/share/applications $out/share/pixmaps $out/share/icons

    copyDesktopItems

    ln -s $out/opt/abevjava.png $out/share/pixmaps/anyk.png
    ln -s $out/opt/abevjava.png $out/share/icons/anyk.png
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Tool for filling forms for the Hungarian government";
    longDescription = ''
      Official tool for filling Hungarian government forms.

      Use `anyk-java` to install form templates/help files like this: `anyk-java -jar NAV_IGAZOL.jar`
    '';
    homepage = "https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/javakitolto";
<<<<<<< HEAD
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ chpatrick ];
    platforms = jre.meta.platforms;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
=======
    license = licenses.unfree;
    maintainers = with maintainers; [ chpatrick ];
    platforms = openjdk.meta.platforms;
    sourceProvenance = [ sourceTypes.binaryBytecode ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "anyk";
  };
}
