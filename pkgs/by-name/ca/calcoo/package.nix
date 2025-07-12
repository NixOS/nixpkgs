{
  lib,
  stdenv,
  fetchzip,
  ant,
  stripJavaArchivesHook,
  jdk,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calcoo";
  version = "2.1.0";

  src = fetchzip {
    url = "mirror://sourceforge/calcoo/calcoo-${finalAttrs.version}.zip";
    hash = "sha256-Bdavj7RaI5CkWiOJY+TPRIRfNelfW5qdl/74J1KZPI0=";
  };

  nativeBuildInputs = [
    ant
    stripJavaArchivesHook
    jdk
    makeWrapper
  ];

  dontConfigure = true;

  env.JAVA_TOOL_OPTIONS = "-Dfile.encoding=iso-8859-1";

  buildPhase = ''
    runHook preBuild
    ant
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/lib/calcoo.jar -t $out/share/calcoo

    makeWrapper ${jdk}/bin/java $out/bin/calcoo \
        --add-flags "-jar $out/share/calcoo/calcoo.jar"

    runHook postInstall
  '';

  meta = {
    changelog = "https://calcoo.sourceforge.net/changelog.html";
    description = "RPN and algebraic scientific calculator";
    homepage = "https://calcoo.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "calcoo";
    maintainers = with lib.maintainers; [ ];
    inherit (jdk.meta) platforms;
  };
})
