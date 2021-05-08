{ lib, stdenv, fetchurl, unzip, makeWrapper
, coreutils, gawk, which, gnugrep, findutils
, jdk
}:

stdenv.mkDerivation {
  pname = "openjump";
  version = "1.15";

  src = fetchurl {
    url = "mirror://sourceforge/jump-pilot/OpenJUMP/1.15/OpenJUMP-Portable-1.15-r6241-CORE.zip";
    sha256 = "12snzkv83w6khcdqzp6xahqapwp82af6c7j2q8n0lj62hk79rfgl";
  };

  # TODO: build from source
  unpackPhase = ''
    mkdir -p $out/bin;
    cd $out; unzip $src
  '';

  nativeBuildInputs = [ makeWrapper unzip ];

  installPhase = ''
    dir=$(echo $out/OpenJUMP-*)

    chmod +x $dir/bin/oj_linux.sh
    makeWrapper $dir/bin/oj_linux.sh $out/bin/OpenJump \
      --set JAVA_HOME ${jdk.home} \
      --set PATH "${coreutils}/bin:${gawk}/bin:${which}/bin:${gnugrep}/bin:${findutils}/bin"
  '';

  meta = {
    description = "Open source Geographic Information System (GIS) written in the Java programming language";
    homepage = "http://www.openjump.org/index.html";
    license = lib.licenses.gpl2;
    maintainers = [lib.maintainers.marcweber];
    platforms = lib.platforms.linux;
  };
}
