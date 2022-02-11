{ stdenv, fetchurl, lib, qtbase, qtmultimedia, qtscript, qtsensors, qtwebengine, qtwebkit, openssl, xkeyboard_config, patchelfUnstable, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "p4v";
  version = "2020.1.1966006";

  src = fetchurl {
    url = "https://cdist2.perforce.com/perforce/r20.1/bin.linux26x86_64/p4v.tgz";
    sha256 = "0zc70d7jgdrd2jli338n1h05hgb7jmmv8hvq205wh78vvllrlv10";
  };

  dontBuild = true;
  nativeBuildInputs = [ patchelfUnstable wrapQtAppsHook ];

  ldLibraryPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      qtbase
      qtmultimedia
      qtscript
      qtsensors
      qtwebengine
      qtwebkit
      openssl
  ];

  dontWrapQtApps = true;
  installPhase = ''
    mkdir $out
    cp -r bin $out
    mkdir -p $out/lib
    cp -r lib/P4VResources $out/lib

    for f in $out/bin/*.bin ; do
      patchelf --set-rpath $ldLibraryPath --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f
      # combining this with above breaks rpath (patchelf bug?)
      patchelf --add-needed libstdc++.so $f \
               --clear-symbol-version _ZNSt20bad_array_new_lengthD1Ev \
               --clear-symbol-version _ZTVSt20bad_array_new_length \
               --clear-symbol-version _ZTISt20bad_array_new_length \
               $f
      wrapQtApp $f \
        --suffix QT_XKB_CONFIG_ROOT : ${xkeyboard_config}/share/X11/xkb
    done
  '';

  dontFixup = true;

  meta = {
    description = "Perforce Visual Client";
    homepage = "https://www.perforce.com";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ nathyong nioncode ];
  };
}
