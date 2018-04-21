{ stdenv, fetchurl, lib, qtbase, qtmultimedia, qtscript, qtsensors, qtwebkit, openssl, xkeyboard_config, makeWrapper }:

stdenv.mkDerivation rec {
  name = "p4v-${version}";
  version = "2017.3.1601999";

  src = fetchurl {
    url = "https://cdist2.perforce.com/perforce/r17.3/bin.linux26x86_64/p4v.tgz";
    sha256 = "f317607f1bc8877db01ff020b8b0857c2d0f8600474d152749264aea0be66b21";
  };

  dontBuild = true;
  nativeBuildInputs = [makeWrapper];

  ldLibraryPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      qtbase
      qtmultimedia
      qtscript
      qtsensors
      qtwebkit
      openssl
  ];

  installPhase = ''
    mkdir $out
    cp -r bin $out
    mkdir -p $out/lib/p4v
    cp -r lib/p4v/P4VResources $out/lib/p4v

    for f in $out/bin/*.bin ; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f

      wrapProgram $f \
        --suffix LD_LIBRARY_PATH : ${ldLibraryPath} \
        --suffix QT_XKB_CONFIG_ROOT : ${xkeyboard_config}/share/X11/xkb \
        --suffix QT_PLUGIN_PATH : ${qtbase.bin}/${qtbase.qtPluginPrefix}
    done
  '';

  meta = {
    description = "Perforce Visual Client";
    homepage = https://www.perforce.com;
    license = stdenv.lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.nioncode ];
  };
}
