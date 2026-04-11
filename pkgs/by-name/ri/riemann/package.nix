{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "riemann";
  version = "0.3.12";

  src = fetchurl {
    url = "https://github.com/riemann/riemann/releases/download/${finalAttrs.version}/riemann-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-gsJMfLo7zpaVfyVmHznGFiomK6dq7yTphuc9vyp5t6Y=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    substituteInPlace bin/riemann --replace '$top/lib/riemann.jar' "$out/share/java/riemann.jar"

    mkdir -p $out/share/java $out/bin $out/etc
    mv lib/riemann.jar $out/share/java/
    mv bin/riemann $out/bin/
    mv etc/riemann.config $out/etc/

    wrapProgram "$out/bin/riemann" --prefix PATH : "${jre}/bin"
  '';

  meta = {
    homepage = "http://riemann.io/";
    description = "Network monitoring system";
    mainProgram = "riemann";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ crimeminister ];
  };
})
