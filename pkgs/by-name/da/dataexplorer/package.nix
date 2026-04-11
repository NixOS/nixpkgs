{
  lib,
  stdenv,
  fetchurl,
  ant,
  openjdk25,
  swt,
  makeWrapper,
  strip-nondeterminism,
  udevCheckHook,
}:
let
  swt-jdk = swt.override { jdk = openjdk25; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dataexplorer";
  version = "4.0.2";

  src = fetchurl {
    url = "mirror://savannah/dataexplorer/dataexplorer-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-HaupE8tCbmlUVMd0ZFt7QwY1AKEx+op21fUeGBpR+UY=";
  };

  nativeBuildInputs = [
    ant
    openjdk25
    makeWrapper
    strip-nondeterminism
    udevCheckHook
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    ant -f build/build.xml dist
    runHook postBuild
  '';

  doCheck = false;
  # Missing dependencies (e.g. junit). Does not work.
  #checkPhase = ''
  #  ant -f build/build.xml check
  #'';

  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    ant -Dprefix=$out/share/ -f build/build.xml install
    # Use SWT from nixpkgs
    ln -sf '${swt-jdk}/jars/swt.jar' "$out/share/DataExplorer/java/ext/swt.jar"

    # The sources contain a wrapper script in $out/share/DataExplorer/DataExplorer
    # but it hardcodes bash shebang and does not pin the java path.
    # So we create our own wrapper, using similar cmdline args as upstream.
    mkdir -p $out/bin
    makeWrapper ${openjdk25}/bin/java $out/bin/DataExplorer \
      --prefix LD_LIBRARY_PATH : '${swt-jdk}/lib' \
      --add-flags "-Xms64m -Xmx3092m -jar $out/share/DataExplorer/DataExplorer.jar" \
      --set SWT_GTK3 0

    makeWrapper ${openjdk25}/bin/java $out/bin/DevicePropertiesEditor \
      --add-flags "-Xms32m -Xmx512m -classpath $out/share/DataExplorer/DataExplorer.jar gde.ui.dialog.edit.DevicePropertiesEditor" \
      --set SWT_GTK3 0 \
      --set LIBOVERLAY_SCROLLBAR 0

    install -Dvm644 build/misc/GNU_LINUX_JUNSI_ICHARER_USB_UDEV_RULE/50-Junsi-iCharger-USB.rules \
      $out/etc/udev/rules.d/50-Junsi-iCharger-USB.rules
    install -Dvm644 build/misc/GNU_LINUX_SKYRC_UDEV_RULE/50-SkyRC-Charger.rules \
      $out/etc/udev/rules.d/50-SkyRC-Charger.rules

    runHook postInstall
  '';

  # manually call strip-nondeterminism because using stripJavaArchivesHook takes
  # too long to strip bundled jars
  postFixup = ''
    strip-nondeterminism --type jar $out/share/DataExplorer/{DataExplorer.jar,devices/*.jar}
  '';

  meta = {
    description = "Graphical tool to analyze data, gathered from various hardware devices";
    homepage = "https://www.nongnu.org/dataexplorer/index.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ panicgh ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # contains RXTXcomm (JNI library with *.so files)
      binaryBytecode # contains thirdparty jar files, e.g. javax.json, org.glassfish.json
    ];
  };
})
