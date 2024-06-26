{
  stdenv,
  lib,
  fetchurl,
  fetchzip,
  openjdk,
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
  extraClasspath = [
    (fetchurl {
      url = "mirror://maven/org/glassfish/metro/webservices-rt/2.4.10/webservices-rt-2.4.10.jar";
      sha256 = "sha256-lHclIZn3HR2B2lMttmmQGIV67qJi5KhL5jT2WNUQpPI=";
    })

    (fetchurl {
      url = "mirror://maven/org/glassfish/metro/webservices-api/2.4.10/webservices-api-2.4.10.jar";
      sha256 = "sha256-1jiabjPkRnh+l/fmTt8aKE5hpeLreYOiLH9sVIcLUQE=";
    })

    (fetchurl {
      url = "mirror://maven/com/sun/activation/jakarta.activation/2.0.1/jakarta.activation-2.0.1.jar";
      sha256 = "sha256-ueJLfdbgdJVWLqllMb4xMMltuk144d/Yitu96/QzKHE=";
    })

    # Patch one of the classes so it works with the packages above by removing .internal. from the package names.
    (runCommandLocal "anyk-patch" { } ''
      mkdir $out
      cd $out
      ${unzip}/bin/unzip ${src}/application/abevjava.jar hu/piller/enykp/niszws/ClientStubBuilder.class
      ${python3}/bin/python ${./patch_paths.py} hu/piller/enykp/niszws/ClientStubBuilder.class
    '')
  ];

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
    exec ${openjdk}/bin/java -Dswing.systemlaf=javax.swing.plaf.metal.MetalLookAndFeel $SCALING_PROP "$@"
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
    (makeDesktopItem rec {
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

    # ÁNYK has some old school dependencies that are no longer bundled with Java, put them on the classpath.
    makeWrapper $out/bin/anyk-java $out/bin/anyk --add-flags "-cp ${lib.concatStringsSep ":" extraClasspath}:$out/opt/abevjava.jar hu.piller.enykp.gui.framework.MainFrame"

    mkdir -p $out/share/applications $out/share/pixmaps $out/share/icons

    copyDesktopItems

    ln -s $out/opt/abevjava.png $out/share/pixmaps/anyk.png
    ln -s $out/opt/abevjava.png $out/share/icons/anyk.png
  '';

  meta = with lib; {
    description = "Tool for filling forms for the Hungarian government,";
    longDescription = ''
      Official tool for filling Hungarian government forms.

      Use `anyk-java` to install form templates/help files like this: `anyk-java -jar NAV_IGAZOL.jar`
    '';
    homepage = "https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/javakitolto";
    license = licenses.unfree;
    maintainers = with maintainers; [ chpatrick ];
    platforms = openjdk.meta.platforms;
    sourceProvenance = [ sourceTypes.binaryBytecode ];
    mainProgram = "anyk";
  };
}
