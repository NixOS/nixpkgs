{ stdenv, fetchurl, lib, qtbase, qtmultimedia, qtscript, qtsensors, qtwebkit, openssl_1_0_2, xkeyboard_config, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "p4v";
  version = "2017.3.1601999";

  src = fetchurl {
    url = "https://cdist2.perforce.com/perforce/r17.3/bin.linux26x86_64/p4v.tgz";
    sha256 = "9ded42683141e1808535ec3e87d3149f890315c192d6e97212794fd54862b9a4";
  };

  dontBuild = true;
  nativeBuildInputs = [ wrapQtAppsHook ];

  ldLibraryPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      qtbase
      qtmultimedia
      qtscript
      qtsensors
      qtwebkit
      openssl_1_0_2
  ];

  dontWrapQtApps = true;
  installPhase = ''
    mkdir $out
    cp -r bin $out
    mkdir -p $out/lib/p4v
    cp -r lib/p4v/P4VResources $out/lib/p4v

    for f in $out/bin/*.bin ; do
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
