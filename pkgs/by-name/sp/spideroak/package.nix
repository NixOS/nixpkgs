{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  patchelf,
  fontconfig,
  freetype,
  glib,
  libICE,
  libSM,
  libX11,
  libXext,
  libXrender,
  zlib,
}:

let
  sha256 = "6d6ca2b383bcc81af1217c696eb77864a2b6db7428f4b5bde5b5913ce705eec5";

  ldpath = lib.makeLibraryPath [
    fontconfig
    freetype
    glib
    libICE
    libSM
    libX11
    libXext
    libXrender
    zlib
  ];

  version = "7.5.0";

in
stdenv.mkDerivation {
  pname = "spideroak";
  inherit version;

  src = fetchurl {
    name = "SpiderOakONE-${version}-slack_tar_x64.tgz";
    url = "https://spideroak-releases.s3.us-east-2.amazonaws.com/SpiderOakONE-${version}-slack_tar_x64.tgz";
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

    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 \
      "$out/opt/SpiderOakONE/lib/SpiderOakONE"

    RPATH=$out/opt/SpiderOakONE/lib:${ldpath}
    makeWrapper $out/opt/SpiderOakONE/lib/SpiderOakONE $out/bin/spideroak --set LD_LIBRARY_PATH $RPATH \
      --set QT_PLUGIN_PATH $out/opt/SpiderOakONE/lib/plugins/ \
      --set SpiderOak_EXEC_SCRIPT $out/bin/spideroak

    sed -i 's/^Exec=.*/Exec=spideroak/' $out/share/applications/SpiderOakONE.desktop
  '';

  nativeBuildInputs = [
    patchelf
    makeWrapper
  ];

  meta = {
    homepage = "https://spideroak.com";
    description = "Secure online backup and sychronization";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "spideroak";
  };
}
