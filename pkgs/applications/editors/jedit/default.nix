{
  lib,
  stdenv,
  fetchsvn,
  ant,
  jdk,
  jre,
  makeWrapper,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jedit";
  version = "5.6.0-unstable-2023-11-19";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/jedit/svn/jEdit/trunk";
    rev = "25703";
    sha256 = "sha256-z1KTZqKl6Dlqayw/3h/JvHQK3kSfio02R8V6aCb4g4Q=";
  };

  ivyDeps = stdenv.mkDerivation {
    name = "jedit-${finalAttrs.version}-ivy-deps";
    inherit (finalAttrs) src;

    nativeBuildInputs = [
      ant
      jdk
    ];

    dontConfigure = true;

    buildPhase = ''
      ant retrieve
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp -r lib/* $out/lib
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
    cp -r build/jedit.jar doc icons keymaps macros modes startup $out/share/jEdit

    install -Dm644 package-files/linux/deb/jedit.desktop -t $out/share/applications
    sed -i "s|Icon=.*|Icon=$out/share/jEdit/icons/jedit-icon48.png|g" $out/share/applications/jedit.desktop

    install -Dm755 package-files/linux/jedit $out/bin/jedit
    sed -i "s|/usr/share/jEdit/@jar.filename@|$out/share/jEdit/jedit.jar|g" $out/bin/jedit
    wrapProgram $out/bin/jedit --set JAVA_HOME ${jre}

    runHook postInstall
  '';

  meta = {
    description = "A programmer's text editor written in Java";
    homepage = "http://www.jedit.org";
    license = lib.licenses.gpl2Only;
    mainProgram = "jedit";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # ivy-deps are .jar files
    ];
  };
})
