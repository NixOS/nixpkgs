{ stdenv, lib, makeWrapper, fetchzip, jre }:

stdenv.mkDerivation rec {
  name = "bftools-${version}";
  version = "5.9.2";

  src = fetchzip {
    url = "http://downloads.openmicroscopy.org/bio-formats/${version}/artifacts/bftools.zip";
    sha256 = "08lmbg3kfxh17q6548il0i2h3f9a6ch8r0r067p14dajhzfpjyqj";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir $out/libexec
    mkdir -p $out/share/java
    cp $(find . -maxdepth 1 -perm -111 -type f) $out/bin
    cp ./*.sh $out/libexec
    cp ./*.jar $out/share/java
    for file in $out/bin/*; do
      substituteInPlace $file --replace "\$BF_DIR" $out/libexec
    done
    substituteInPlace $out/libexec/bf.sh --replace "\$BF_JAR_DIR" $out/share/java
  '';

  postFixup = ''
    chmod +x $out/bin/bf.sh
    wrapProgram $out/bin/bf.sh --prefix PATH : "${lib.makeBinPath [ jre ]}"
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with stdenv.lib; {
    description = "A bundle of scripts for using Bio-Formats on the command line with bioformats_package.jar already included";
    license = licenses.gpl2;
    platforms = platforms.all;
    homepage = https://www.openmicroscopy.org/bio-formats/;
    maintainers = [ maintainers.tbenst ];
  };
}
