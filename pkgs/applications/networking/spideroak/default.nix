{ stdenv, fetchurl, makeWrapper, patchelf
, fontconfig, freetype, glib, libICE, libSM
, libX11, libXext, libXrender, zlib
}:

let
  arch = if stdenv.system == "x86_64-linux" then "x86_64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Spideroak client for: ${stdenv.system} not supported!";

  interpreter = if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2"
    else if stdenv.system == "i686-linux" then "ld-linux.so.2"
    else throw "Spideroak client for: ${stdenv.system} not supported!";

  sha256 = if stdenv.system == "x86_64-linux" then "0k87rn4aj0v79rz9jvwspnwzmh031ih0y74ra88nc8kl8j6b6gjm"
    else if stdenv.system == "i686-linux" then "1wbxfikj8f7rx26asswqrfp9vpk8w5941s21y1pnaff2gcac8m3z"
    else throw "Spideroak client for: ${stdenv.system} not supported!";

  ldpath = stdenv.lib.makeLibraryPath [
    fontconfig freetype glib libICE libSM
    libX11 libXext libXrender zlib
  ];

  version = "6.1.9";

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

    rm -f $out/opt/SpiderOakONE/lib/libz*

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
