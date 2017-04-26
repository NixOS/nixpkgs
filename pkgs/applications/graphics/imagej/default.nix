{ stdenv, lib, fetchurl, jre, unzip, makeWrapper }:

rec {
  imagej = imagej150;

  imagej150 = stdenv.mkDerivation rec {
    name = "imagej-${version}";
    version = "150";

    src = fetchurl {
      url = "http://wsr.imagej.net/distros/cross-platform/ij150.zip";
      sha256 = "97aba6fc5eb908f5160243aebcdc4965726693cb1353d9c0d71b8f5dd832cb7b";
    };
    buildInputs = [ unzip makeWrapper ];
    inherit jre;

    # JAR files that are intended to be used by other packages
    # should go to $out/share/java.
    installPhase = ''
      mkdir -p $out/share/java
      cp ij.jar $out/share/java
      mkdir $out/bin
      makeWrapper ${jre}/bin/java $out/bin/imagej \
        --add-flags "-cp $out/share/java/ij.jar ij.ImageJ"
    '';
  };

  meta = {
    homepage = https://imagej.nih.gov/ij/;
    description = "Image processing and analysis in Java";
    longDescription = ''
      ImageJ is a public domain Java image processing program
      inspired by NIH Image for the Macintosh.
      It runs on any computer with a Java 1.4 or later virtual machine.
    '';
    license = lib.licenses.publicDomain;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = [ "Yuri Aisaka <yuri.aisaka+nix@gmail.com>" ];
  };
}
