{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "jhiccup";
  version = "2.0.10";

  src = fetchzip {
    url = "https://www.azul.com/files/jHiccup-${version}-dist.zip";
    sha256 = "1hsvi8wjh615fnjf75h7b5afp04chqcgvini30vfcn3m9a5icbgy";
  };

  dontConfigure = true;
  buildPhase = ":";
  installPhase = ''
    mkdir -p $out/bin $out/share/java
    cp *.jar $out/share/java

    # Fix version number (out of date at time of import), and path to
    # jHiccup.jar
    for x in ./jHiccup ./jHiccupLogProcessor; do
      substituteInPlace $x \
        --replace 'JHICCUP_Version=2.0.5' 'JHICCUP_Version=${version}' \
        --replace '$INSTALLED_PATH' $out/share/java
    done

    mv jHiccup jHiccupLogProcessor $out/bin/
  '';

  meta = {
    description = "Measure JVM application stalls and GC pauses";
    homepage = "https://www.azul.com/jhiccup/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.cc0;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
