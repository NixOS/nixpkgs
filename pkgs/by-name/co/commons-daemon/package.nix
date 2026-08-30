{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.5.1";
  pname = "commons-daemon";

  src = fetchurl {
    url = "mirror://apache/commons/daemon/binaries/commons-daemon-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-pw+2L45wlKKtN0qKkihfbOyP+m9+kEHGdJ2WsovcxlY=";
  };

  installPhase = ''
    tar xf ${finalAttrs.src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage = "https://commons.apache.org/proper/commons-daemon";
    description = "Apache Commons Daemon software is a set of utilities and Java support classes for running Java applications as server processes";
    maintainers = with lib.maintainers; [ rsynnest ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
})
