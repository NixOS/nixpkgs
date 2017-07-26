{ stdenv, fetchurl, jre, unzip, makeWrapper }:

# Note:
# - User config dir is hard coded by upstream to $HOME/.imagej on linux systems
#   and to $HOME/Library/Preferences on macOS.
#  (The current trend appears to be to use $HOME/.config/imagej
#    on linux systems, but we here do not attempt to fix it.)

let
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
    # (Some uses ij.jar as a library not as a standalone program.)
    installPhase = ''
      mkdir -p $out/share/java
      # Read permisssion suffices for the jar and others.
      # Simple cp shall clear suid bits, if any.
      cp ij.jar $out/share/java
      cp -dR luts macros plugins $out/share
      mkdir $out/bin
      makeWrapper ${jre}/bin/java $out/bin/imagej \
        --add-flags "-jar $out/share/java/ij.jar -ijpath $out/share"
    '';
    meta = with stdenv.lib; {
      homepage = https://imagej.nih.gov/ij/;
      description = "Image processing and analysis in Java";
      longDescription = ''
        ImageJ is a public domain Java image processing program
        inspired by NIH Image for the Macintosh.
        It runs on any computer with a Java 1.4 or later virtual machine.
      '';
      license = licenses.publicDomain;
      platforms = with platforms; linux ++ darwin;
      maintainers = with maintainers; [ yuriaisaka ];
    };
  };
in
  imagej150
