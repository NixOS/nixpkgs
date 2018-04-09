{ stdenv, fetchurl, makeWrapper, patchelf
, fontconfig, freetype, glib, libICE, libSM
, libX11, libXext, libXrender, zlib
}:

let
  arch = if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "x86"
    else throw "Spideroak client for: ${stdenv.system} not supported!";

  interpreter = if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2"
    else if stdenv.system == "i686-linux" then "ld-linux.so.2"
    else throw "Spideroak client for: ${stdenv.system} not supported!";

  sha256 = if stdenv.system == "x86_64-linux" then "993e01986e3657d6fa979b8d0f45ac25b8223c18f75555016a9f92e651e91b1f"
    else if stdenv.system == "i686-linux" then "d12c09c3a01bfa48bdecc8763bbf2c7f10b71cea5bcecc177dad031ba79bc83d"
    else throw "Spideroak client for: ${stdenv.system} not supported!";

  ldpath = stdenv.lib.makeLibraryPath [
    fontconfig freetype glib libICE libSM
    libX11 libXext libXrender zlib
  ];

  version = "7.0.1";

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

  buildInputs = [ patchelf makeWrapper ];

  meta = {
    homepage = https://spideroak.com;
    description = "Secure online backup and sychronization";
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ amorsillo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
