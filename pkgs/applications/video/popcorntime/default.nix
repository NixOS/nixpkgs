{ lib, stdenv, fetchurl, runCommand, makeWrapper, node_webkit_0_9,
  fromCi ? true,
  build ? "652",
  version ? if fromCi then "0.3.7-2-0ac62b848" else "0.3.7.2"
}:

let
  config = 
    if stdenv.system == "x86_64-linux" then 
      {sys = "Linux32"; 
       sha256 = 
          if fromCi then "06av40b68xy2mv2fp9qg8npqmnvkl00p2jvbm2fdfnpc9jj746iy"
                    else "0lm9k4fr73a9p00i3xj2ywa4wvjf9csadm0pcz8d6imwwq44sa8b";
      }
    else if stdenv.system == "i686-linux" then 
      {sys = "Linux64"; 
       sha256 = 
        if fromCi then "1nr2zaixdr5vqynga7jig3fw9dckcnzcbdmbr8haq4a486x2nq0f"
                  else "1dz1cp31qbwamm9pf8ydmzzhnb6d9z73bigdv3y74dgicz3dpr91";
      }
    else throw "Unsupported system ${stdenv.system}";

  fetchurlConf = 
    let
      ciBase = "https://ci.popcorntime.io/job/Popcorn-Experimental/652/artifact/build/releases/Popcorn-Time";
      relBase = "https://get.popcorntime.io/build";
    in {
      url = 
        if fromCi then "${ciBase}/${lib.toLower config.sys}/Popcorn-Time-${version}-${config.sys}.tar.xz"
        else "${relBase}/Popcorn-Time-${version}-Linux64.tar.xz";
      sha256 = config.sha256;
    };

  popcorntimePackage = stdenv.mkDerivation rec {
    name = 
      if fromCi then "popcorntime-git-2015-07-07"
                else "popcorntime-${version}";
    src = fetchurl fetchurlConf;
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out
      cp -r *.so *.pak $out/
      cat ${node_webkit_0_9}/bin/nw package.nw > $out/Popcorn-Time
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
