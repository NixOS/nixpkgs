{
  lib,
  stdenv,
  fetchurl,
  openjdk,
  runtimeShell,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "leo3";
  version = "1.7.18";

  src = fetchurl {
    url = "https://github.com/leoprover/Leo-III/releases/download/v${finalAttrs.version}/leo3-v${finalAttrs.version}.jar";
    sha256 = "sha256-HEUi8Krxv9u9Rq/2Gu0Tts86sseaAZq+pccJ4Q5MRr0=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out"/{bin,lib/java/leo3}
    cp "${finalAttrs.src}" "$out/lib/java/leo3/leo3.jar"
    echo "#!${runtimeShell}" > "$out/bin/leo3"
    echo "'${openjdk}/bin/java' -jar '$out/lib/java/leo3/leo3.jar' \"\$@\""  >> "$out/bin/leo3"
    chmod a+x "$out/bin/leo3"
  '';

  meta = {
    description = "Automated theorem prover for classical higher-order logic with choice";
    mainProgram = "leo3";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://page.mi.fu-berlin.de/lex/leo3/";
  };
})
