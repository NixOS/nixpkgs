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

  sha256 = if stdenv.system == "x86_64-linux" then "0ax5ij3fwq3q9agf7qkw2zg53fcd82llg734pq3swzpn3z1ajs38"
    else if stdenv.system == "i686-linux" then "18hvgx8bvd2khnqfn434gd4mflv0w5y8kvim72rvya2kwxsyf3i1"
    else throw "Spideroak client for: ${stdenv.system} not supported!";

  ldpath = stdenv.lib.makeSearchPath "lib" [
    glib fontconfig libXext libX11 freetype libXrender 
  ];

  version = "5.1.6";

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
    ensureDir "$out"
    cp -r "./"* "$out"
    ensureDir "$out/bin"
    rm "$out/usr/bin/SpiderOak"

    patchelf --set-interpreter ${stdenv.glibc}/lib/${interpreter} \
      "$out/opt/SpiderOak/lib/SpiderOak"

    RPATH=$out/opt/SpiderOak/lib:${ldpath}
    makeWrapper $out/opt/SpiderOak/lib/SpiderOak $out/bin/spideroak --set LD_LIBRARY_PATH $RPATH \
      --set QT_PLUGIN_PATH $out/opt/SpiderOak/lib/plugins/ \
      --set SpiderOak_EXEC_SCRIPT $out/bin/spideroak
  '';

  buildInputs = [ patchelf makeWrapper ];

  meta = {
    homepage = "https://spideroak.com";
    description = "Secure online backup and sychronization";
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ amorsillo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
