{ stdenv, fetchurl, makeWrapper, glib
, fontconfig, patchelf, libXext, libX11
, freetype, libXrender
}:

let
  arch = if stdenv.system == "x86_64-linux" then "x86_64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Spideroak client for: ${stdenv.system} not supported!";

  interpreter = if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2"
    else if stdenv.system == "i686-linux" then "ld-linux.so.2"
    else throw "Spideroak client for: ${stdenv.system} not supported!";

  sha256 = if stdenv.system == "x86_64-linux" then "88fd785647def79ee36621fa2a8a5bea73c513de03103f068dd10bc25f3cf356"
    else if stdenv.system == "i686-linux" then "8c23271291f40aa144bbf38ceb3cc2a05bed00759c87a65bd798cf8bb289d07a"
    else throw "Spideroak client for: ${stdenv.system} not supported!";

  ldpath = stdenv.lib.makeLibraryPath [
    glib fontconfig libXext libX11 freetype libXrender
  ];

  version = "6.0.1";

in stdenv.mkDerivation {
  name = "spideroak-${version}";

  src = fetchurl {
    name = "spideroak-${version}-${arch}";
    url = "https://spideroak.com/getbuild?platform=slackware&arch=${arch}&version=${version}";
    inherit sha256;
  };

  sourceRoot = ".";

  unpackCmd = "tar -xzf $curSrc";

  installPhase = ''
    mkdir "$out"
    cp -r "./"* "$out"
    mkdir "$out/bin"
    rm "$out/usr/bin/SpiderOakONE"
    rmdir $out/usr/bin || true
    mv $out/usr/share $out/

    patchelf --set-interpreter ${stdenv.glibc.out}/lib/${interpreter} \
      "$out/opt/SpiderOakONE/lib/SpiderOakONE"

    RPATH=$out/opt/SpiderOakONE/lib:${ldpath}
    makeWrapper $out/opt/SpiderOakONE/lib/SpiderOakONE $out/bin/spideroak --set LD_LIBRARY_PATH $RPATH \
      --set QT_PLUGIN_PATH $out/opt/SpiderOakONE/lib/plugins/ \
      --set SpiderOak_EXEC_SCRIPT $out/bin/spideroak

    sed -i 's/^Exec=.*/Exec=spideroak/' $out/share/applications/SpiderOakONE.desktop
  '';

  buildInputs = [ patchelf makeWrapper ];

  meta = {
    homepage = https://spideroak.com;
    description = "Secure online backup and sychronization";
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ amorsillo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
