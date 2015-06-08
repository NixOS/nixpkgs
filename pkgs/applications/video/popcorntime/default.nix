{ stdenv, pkgs, fetchurl, runCommand, makeWrapper, node_webkit_0_9
}:

let
  node-webkit = node_webkit_0_9;
  version = "0.3.7.2";
  popcorntimePackage = stdenv.mkDerivation rec {
    name = "popcorntime-package-${version}";
    src = fetchurl {
      url = "https://get.popcorntime.io/build/Popcorn-Time-${version}-Linux64.tar.xz";
     sha256 = "0lm9k4fr73a9p00i3xj2ywa4wvjf9csadm0pcz8d6imwwq44sa8b";
    };
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out
      cp -r *.so *.pak $out/
      cat ${node-webkit}/bin/nw package.nw > $out/Popcorn-Time
      chmod 555 $out/Popcorn-Time
    '';
  };
in
  runCommand "popcorntime-${version}" {
    buildInputs = [ makeWrapper ];
    meta = with stdenv.lib; {
      homepage = http://popcorntime.io/;
      description = "An application that streams movies and TV shows from torrents";
      license = stdenv.lib.licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bobvanderlinden ];
    };
  }
  ''
    mkdir -p $out/bin
    makeWrapper ${popcorntimePackage}/Popcorn-Time $out/bin/popcorntime
  ''
