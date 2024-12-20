{
  lib,
  stdenv,
  fetchurl,
  ant,
  jdk,
  jre,
  makeWrapper,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freemind";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/freemind/freemind-src-${finalAttrs.version}.tar.gz";
    hash = "sha256-AYKFEmsn6uc5K4w7+1E/Jb1wuZB0QOXrggnyC0+9hhk=";
  };

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    stripJavaArchivesHook
  ];

  postPatch = ''
    # disable the <buildnumer> task because it would edit version.properties
    # and add a "last edited" header to it, which is non-deterministic
    sed -i  '/<buildnumber/d' build.xml

    # replace dependency on `which`
    substituteInPlace freemind.sh \
        --replace-fail "which" "type -p"
  '';

  preConfigure = ''
    chmod +x *.sh
    patchShebangs *.sh
  '';

  # Workaround for javac encoding errors
  # Note: not sure if this is still needed
  env.JAVA_TOOL_OPTIONS = "-Dfile.encoding=UTF8";

  buildPhase = ''
    runHook preBuild
    ant build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ant dist -Ddist=$out/share/freemind
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/share/freemind/freemind.sh $out/bin/freemind \
        --set JAVA_HOME ${jre}
  '';

  meta = {
    description = "Mind-mapping software";
    homepage = "https://freemind.sourceforge.net/wiki/index.php/Main_Page";
    mainProgram = "freemind";
    maintainers = with lib.maintainers; [ tomasajt ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
  };
})
