{
  lib,
  stdenv,
  fetchzip,
  ant,
  jdk8,
  sharutils,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freetts";
  version = "1.2.2";

  src = fetchzip {
    url = "mirror://sourceforge/freetts/freetts-${finalAttrs.version}-src.zip";
    hash = "sha256-+bhM0ErEZVnmcz5CBqn/AeGaOhKnCjZzGeqgO/89wms=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    ant
    jdk8
    sharutils
    stripJavaArchivesHook
  ];

  sourceRoot = "${finalAttrs.src.name}/freetts-${finalAttrs.version}";

  buildPhase = ''
    runHook preBuild

    pushd lib
    sed -i -e "s/more/cat/" jsapi.sh
    echo y | sh jsapi.sh
    popd

    ln -s . src
    ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 lib/*.jar -t $out/lib
    runHook postInstall
  '';

  meta = with lib; {
    description = "Text to speech system based on Festival written in Java";
    longDescription = ''
      Text to speech system based on Festival written in Java.
      Can be used in combination with KDE accessibility.
    '';
    homepage = "http://freetts.sourceforge.net";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ sander ];
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # jsapi.jar is bundled in a self-extracting shell-script
    ];
  };
})
