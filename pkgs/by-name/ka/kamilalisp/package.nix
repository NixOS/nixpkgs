{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kamilalisp";
  version = "0.3.0.1";

  src = fetchurl {
    url = "https://github.com/kspalaiologos/kamilalisp/releases/download/v${finalAttrs.version}/kamilalisp-${finalAttrs.version}.jar";
    hash = "sha256-SW0U483eHptkYw+yJV/2cImfK3uEjkl8ma54yeagF6s=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${finalAttrs.src} $out/share/java/kamilalisp-${finalAttrs.version}.jar
    makeWrapper ${jre}/bin/java $out/bin/kamilalisp \
      --add-flags "-jar $out/share/java/kamilalisp-${finalAttrs.version}.jar" \
      --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp" \
      --set _JAVA_AWT_WM_NONREPARENTING 1
  '';

  meta = {
    homepage = "https://github.com/kspalaiologos/kamilalisp";
    description = "Functional, flexible, and concise Lisp";
    mainProgram = "kamilalisp";
    license = lib.licenses.gpl3Plus;
    inherit (jre.meta) platforms;
    maintainers = with lib.maintainers; [ cafkafk ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
