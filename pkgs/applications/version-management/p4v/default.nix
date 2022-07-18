{ stdenv
, fetchurl
, lib
, qtbase
, qtwebengine
, qtdeclarative
, qtwebchannel
, syntax-highlighting
, openssl
, xkeyboard_config
, patchelfUnstable
, wrapQtAppsHook
, writeText
}:
let
  # This abomination exists because p4v calls CRYPTO_set_mem_functions and
  # expects it to succeed. The function will fail if CRYPTO_malloc has already
  # been called, which happens at init time via qtwebengine -> ... -> libssh. I
  # suspect it was meant to work with a version of Qt where openssl is
  # statically linked or some other library is used.
  crypto-hack = writeText "crypto-hack.c" ''
      #include <stddef.h>
      int CRYPTO_set_mem_functions(
            void *(*m)(size_t, const char *, int),
            void *(*r)(void *, size_t, const char *, int),
            void (*f)(void *, const char *, int)) { return 1; }
    '';

in stdenv.mkDerivation rec {
  pname = "p4v";
  version = "2021.3.2186916";

  src = fetchurl {
    url = "http://web.archive.org/web/20211118024745/https://cdist2.perforce.com/perforce/r21.3/bin.linux26x86_64/p4v.tgz";
    sha256 = "1zldg21xq4srww9pcfbv3p8320ghjnh333pz5r70z1gwbq4vf3jq";
  };

  dontBuild = true;
  nativeBuildInputs = [ patchelfUnstable wrapQtAppsHook ];

  ldLibraryPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      qtbase
      qtwebengine
      qtdeclarative
      qtwebchannel
      syntax-highlighting
      openssl
  ];

  dontWrapQtApps = true;
  installPhase = ''
    mkdir $out
    cp -r bin $out
    mkdir -p $out/lib
    cp -r lib/P4VResources $out/lib
    $CC -fPIC -shared -o $out/lib/libcrypto-hack.so ${crypto-hack}

    for f in $out/bin/*.bin ; do
      patchelf --set-rpath $ldLibraryPath --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f
      # combining this with above breaks rpath (patchelf bug?)
      patchelf --add-needed libstdc++.so \
               --add-needed $out/lib/libcrypto-hack.so \
               --clear-symbol-version _ZNSt20bad_array_new_lengthD1Ev \
               --clear-symbol-version _ZTVSt20bad_array_new_length \
               --clear-symbol-version _ZTISt20bad_array_new_length \
               --clear-symbol-version _ZdlPvm \
               $f
      wrapQtApp $f \
        --suffix QT_XKB_CONFIG_ROOT : ${xkeyboard_config}/share/X11/xkb
    done
  '';

  dontFixup = true;

  meta = {
    description = "Perforce Visual Client";
    homepage = "https://www.perforce.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ nathyong nioncode ];
  };
}
