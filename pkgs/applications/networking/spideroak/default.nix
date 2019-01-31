{ stdenv, fetchurl, makeWrapper, patchelf
, fontconfig, freetype, glib, libICE, libSM
, libX11, libXext, libXrender, zlib
}:

let
  arch = if stdenv.hostPlatform.system == "x86_64-linux" then "x64"
    else throw "Spideroak client for: ${stdenv.hostPlatform.system} not supported!";

  interpreter = if stdenv.hostPlatform.system == "x86_64-linux" then "ld-linux-x86-64.so.2"
    else throw "Spideroak client for: ${stdenv.hostPlatform.system} not supported!";

  sha256 = if stdenv.hostPlatform.system == "x86_64-linux" then "a54f2fd298a673602e9583b8f65d165b3e14b0645a27049e4a269074a00f5793"
    else throw "Spideroak client for: ${stdenv.hostPlatform.system} not supported!";

  ldpath = stdenv.lib.makeLibraryPath [
    fontconfig freetype glib libICE libSM
    libX11 libXext libXrender zlib
  ];

  version = "7.3.0";

in stdenv.mkDerivation {
  name = "spideroak-${version}";

  src = fetchurl {
    name = "SpiderOakONE-${version}-slack_tar_${arch}.tgz";
    url = "https://spideroak.com/release/spideroak/slack_tar_${arch}";
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

  nativeBuildInputs = [ patchelf makeWrapper ];

  meta = {
    homepage = https://spideroak.com;
    description = "Secure online backup and sychronization";
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ amorsillo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
