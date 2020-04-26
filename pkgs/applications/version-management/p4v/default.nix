{ stdenv, fetchurl, lib, qtbase, qtscript, qtwebengine, qtwebkit, openssl_1_1, xkeyboard_config, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "p4v";
  version = "2020.1.1946989";

  src = fetchurl {
    url = "https://www.perforce.com/downloads/perforce/r20.1/bin.linux26x86_64/p4v.tgz";
    sha256 = "67aa4949fb29b04b537f32b3f8fc18a24ef3ce12f81a38ffea46210a89553a89";
  };

  dontBuild = true;
  nativeBuildInputs = [ wrapQtAppsHook ];

  ldLibraryPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      qtbase
      qtscript
      qtwebengine
      qtwebkit
      openssl_1_1
  ];

  dontWrapQtApps = true;
  installPhase = ''
    mkdir $out
    cp -r bin $out
    mkdir -p $out/lib
    cp -r lib/P4VResources $out/lib

    for f in $out/bin/{*.bin,helixmfa,QtWebEngineProcess} ; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f

      wrapQtApp $f \
        --suffix LD_LIBRARY_PATH : ${ldLibraryPath} \
        --suffix QT_XKB_CONFIG_ROOT : ${xkeyboard_config}/share/X11/xkb
    done
  '';

  meta = {
    description = "Perforce Visual Client";
    homepage = "https://www.perforce.com";
    license = stdenv.lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ nathyong nioncode ];
  };
}
