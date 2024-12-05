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
  version = "5.6.0-unstable-2023-11-19";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/jedit/svn/jEdit/trunk";
    rev = "25703";
    hash = "sha256-z1KTZqKl6Dlqayw/3h/JvHQK3kSfio02R8V6aCb4g4Q=";
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
    outputHash = "sha256-J5i5IhXlXw84y/4K6Vt84au4eVXVLupmtfscO+y1Fi0=";
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
    description = "Programmer's text editor written in Java";
    homepage = "http://www.jedit.org";
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
