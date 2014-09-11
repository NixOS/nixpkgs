{ stdenv, fetchurl, makeWrapper, jre, which, git, xlibs, glib, gtk2
}:

assert stdenv.isLinux;

let version = "6_0_6";

in

stdenv.mkDerivation rec {
  name = "smartgithg-${version}";

  src = fetchurl {
    url = "http://www.syntevo.com/download/smartgithg/smartgithg-generic-${version}.tar.gz";
    sha256 = "1ri6hh6hi09ks1yivm84w3p191lysba5dgz0zfaq7wcf2dh1br0k";
  };

  buildInputs = [ makeWrapper ];

  buildCommand =
  ''
    tar xvzf $src
    mkdir -p $out
    sgh=smartgithg-${version}
    cp -a $sgh $out

    mkdir -p $out/bin

    jre=${jre}/lib/openjdk

    makeWrapper $out/$sgh/bin/smartgithg.sh $out/bin/smartgit \
      --prefix PATH : ${jre}/bin:${which}/bin:${gtk2}/lib:${git}/bin \
      --prefix LD_LIBRARY_PATH : ${xlibs.libXtst}/lib:${glib}/lib:${gtk2}/lib \
      --prefix JRE_HOME : $jre \
      --prefix JAVA_HOME : $jre

      patchShebangs $out
  '';

  meta = {
    description = "Graphical Git client";
    homepage = http://www.syntevo.com/smartgit/;
    longDescription =
    ''
      SmartGit is a Git client with support for GitHub Pull Requests+Comments, SVN and Mercurial.
    '';
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.unfree;
  };
}

