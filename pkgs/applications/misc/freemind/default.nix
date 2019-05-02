{ stdenv, fetchurl, jdk, jre, ant }:

stdenv.mkDerivation rec {
  name = "freemind-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/freemind/freemind-src-${version}.tar.gz";
    sha256 = "06c6pm7hpwh9hbmyah3lj2wp1g957x8znfwc5cwygsi7dc98b0h1";
  };

  buildInputs = [ jdk ant ];

  preConfigure = ''
    chmod +x check_for_duplicate_resources.sh
    sed 's,/bin/bash,${stdenv.shell},' -i check_for_duplicate_resources.sh

    ## work around javac encoding errors
    export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
  '';

  buildPhase = "ant dist";

  installPhase = ''
    mkdir -p $out/{bin,nix-support}
    cp -r ../bin/dist $out/nix-support
    sed -i 's/which/type -p/' $out/nix-support/dist/freemind.sh

    cat >$out/bin/freemind <<EOF
    #! ${stdenv.shell}
    JAVA_HOME=${jre} $out/nix-support/dist/freemind.sh
    EOF
    chmod +x $out/{bin/freemind,nix-support/dist/freemind.sh}
  '';

  meta = with stdenv.lib; {
    description = "Mind-mapping software";
    homepage = http://freemind.sourceforge.net/wiki/index.php/Main_Page;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
