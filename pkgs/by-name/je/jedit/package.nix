{
  lib,
  stdenv,
  fetchsvn,
  ant,
  jdk,
  jre,
  xmlstarlet,
  makeWrapper,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jedit";
  version = "5.7.0";

  src =
    let
      versionWithDashes = lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version;
    in
    fetchsvn {
      url = "https://svn.code.sf.net/p/jedit/svn/jEdit/tags/jedit-${versionWithDashes}";
      hash = "sha256-XfYK2C0QZrg4b//1eQcUNViRthBbXV+cbcYetzw2RG8=";
    };

  ivyDeps = stdenv.mkDerivation {
    name = "${finalAttrs.pname}-${finalAttrs.version}-ivy-deps";
    inherit (finalAttrs) src;

    nativeBuildInputs = [
      ant
      jdk
      xmlstarlet
    ];

    # set defaultCacheDir to something that can exist
    # this directory won't get copied, but needs to be set properly
    configurePhase = ''
      runHook preConfigure

      xmlstarlet ed --subnode /ivysettings -t elem -n caches ivysettings.xml \
          | xmlstarlet ed --insert /ivysettings/caches -t attr -n defaultCacheDir -v "$(pwd)/ivy-cache" \
          > ivysettings.xml.tmp
      mv ivysettings.xml.tmp ivysettings.xml

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      ant retrieve
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      cp -r lib/* $out/lib
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-NGSBGB7q0HpOpajJV68K0rqCOqFYNrZHsnUHW+1GSLs=";
  };

  # ignore a test failing because of the build environment
  postPatch = ''
    substituteInPlace test/org/gjt/sp/jedit/MiscUtilitiesTest.java \
        --replace-fail "public class MiscUtilitiesTest" "@org.junit.Ignore public class MiscUtilitiesTest"
  '';

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild
    ln -s ${finalAttrs.ivyDeps}/lib ./lib
    ant build -Divy.done=true
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/jEdit
    cp -r build/jedit.jar doc keymaps macros modes startup $out/share/jEdit

    install -Dm644 icons/jedit-icon48.png $out/share/icons/hicolor/48x48/apps/jedit.png
    install -Dm644 package-files/linux/deb/jedit.desktop -t $out/share/applications

    sed -i $out/share/applications/jedit.desktop \
        -e "s|Icon=.*|Icon=jedit|g" \
        -e "s|Exec=.*|Exec=jedit|g"

    install -Dm755 package-files/linux/jedit -t $out/bin
    substituteInPlace $out/bin/jedit \
        --replace-fail "/usr/share/jEdit/@jar.filename@" "$out/share/jEdit/jedit.jar"

    wrapProgram $out/bin/jedit --set JAVA_HOME ${jre}

    runHook postInstall
  '';

  meta = {
    changelog = "${finalAttrs.src.url}/doc/CHANGES.txt";
    description = "Programmer's text editor written in Java";
    homepage = "https://www.jedit.org";
    license = lib.licenses.gpl2Only;
    mainProgram = "jedit";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # ivyDeps contains .jar dependencies
    ];
  };
})
