{
  lib,
  stdenv,
  fetchzip,
  jre_headless,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmlbeans";
  version = "5.3.0-20241203";

  src = fetchzip {
    # old releases are deleted from the cdn
    url = "https://web.archive.org/web/20250404194918/https://dlcdn.apache.org/poi/xmlbeans/release/bin/apache-xmlbeans-bin-5.3.0-20241203.zip";
    hash = "sha256-AeV+s0VfBgb0YbsY6dNJeqcsguZhDmjuyqXT/415a3k=";
    stripRoot = false;
  };

  postPatch = ''
    cp -r apache-xmlbeans-*/* .
    rm -r apache-xmlbeans-*
    rm bin/*.cmd
    substituteInPlace bin/dumpxsb \
      --replace-fail 'echo `dirname $0`' ""
    substituteInPlace bin/_setlib \
      --replace-fail 'echo XMLBEANS_LIB=$XMLBEANS_LIB' ""
    for file in bin/*; do
      substituteInPlace $file \
        --replace-warn "java " "${jre_headless}/bin/java "
    done
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    chmod +x bin/*
    cp -r bin/ lib/ $out/

    runHook postInstall
  '';

  meta = {
    description = "Java library for accessing XML by binding it to Java types";
    homepage = "https://xmlbeans.apache.org/";
    downloadPage = "https://dlcdn.apache.org/poi/xmlbeans/release/bin/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
