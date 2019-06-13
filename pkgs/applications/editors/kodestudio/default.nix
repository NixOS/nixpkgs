{ stdenv, lib, fetchurl, makeDesktopItem, makeWrapper
, # Patchelf dependencies:
  alsaLib, atomEnv, boehmgc, flac, libogg, libvorbis, libXScrnSaver, libGLU_combined
, openssl, xorg, zlib
}:

let

  version = "17.1";

  sha256 = if stdenv.hostPlatform.system == "x86_64-linux"  then "1kddisnvlk48jip6k59mw3wlkrl7rkck2lxpaghn0gfx02cvms5f"
      else if stdenv.hostPlatform.system == "i686-cygwin"   then "1izp42afrlh4yd322ax9w85ki388gnkqfqbw8dwnn4k3j7r5487z"
      else throw "Unsupported system: ${stdenv.hostPlatform.system}";

  urlBase = "https://github.com/Kode/KodeStudio/releases/download/v${version}/KodeStudio-";

  urlStr = if stdenv.hostPlatform.system == "x86_64-linux"  then urlBase + "linux64.tar.gz"
      else if stdenv.hostPlatform.system == "i686-cygwin"   then urlBase + "win32.zip"
      else throw "Unsupported system: ${stdenv.hostPlatform.system}";

in

  stdenv.mkDerivation rec {
    name = "kodestudio-${version}";

    src = fetchurl {
        url = urlStr;
        inherit sha256;
    };

    buildInputs = [ makeWrapper libXScrnSaver ];

    desktopItem = makeDesktopItem {
      name = "kodestudio";
      exec = "kodestudio";
      icon = "kodestudio";
      comment = "Kode Studio is an IDE for Kha based on Visual Studio Code";
      desktopName = "Kode Studio";
      genericName = "Text Editor";
      categories = "GNOME;GTK;Utility;TextEditor;Development;";
    };

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out
    '';

    postFixup = lib.optionalString (stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux") ''
      # Patch Binaries
      patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "$out:${atomEnv.libPath}" \
          $out/kodestudio
      patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ".:${stdenv.cc.libc}/lib:${xorg.libXinerama}/lib:${xorg.libX11}/lib:${alsaLib}/lib:${libGLU_combined}/lib:${openssl.out}/lib" \
          $out/resources/app/extensions/krom/Krom/linux/Krom
      patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ".:${stdenv.cc.libc}/lib" \
          $out/resources/app/extensions/kha/Kha/Kore/Tools/krafix/krafix-linux64
      patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ".:${stdenv.cc.libc}/lib" \
          $out/resources/app/extensions/kha/Kha/Kore/Tools/kraffiti/kraffiti-linux64
      patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" \
          $out/resources/app/extensions/kha/Kha/Tools/kravur/kravur-linux64
      patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ".:${stdenv.cc.libc}/lib:${zlib}/lib" \
          $out/resources/app/extensions/kha/Kha/Tools/haxe/haxe-linux64
      patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ".:${stdenv.cc.libc}/lib:${libvorbis}/lib:${libogg}/lib:${flac.out}/lib" \
          $out/resources/app/extensions/kha/Kha/Tools/oggenc/oggenc-linux64

      # Patch Shared Objects
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/libnode.so
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib" $out/libffmpeg.so
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/resources/app/extensions/krom/Krom/linux/libv8_libplatform.so
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/resources/app/extensions/krom/Krom/linux/libicuuc.so
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/resources/app/extensions/krom/Krom/linux/libv8_libbase.so
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/resources/app/extensions/krom/Krom/linux/libv8.so
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/resources/app/extensions/krom/Krom/linux/libicui18n.so
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${boehmgc}/lib" $out/resources/app/extensions/kha/Kha/Backends/Kore/khacpp/project/libs/nekoapi/bin/RPi/libneko.so
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${boehmgc}/lib" $out/resources/app/extensions/kha/Kha/Backends/Kore/khacpp/project/libs/nekoapi/bin/Linux64/libneko.so
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${boehmgc}/lib" $out/resources/app/extensions/kha/Kha/Backends/Kore/khacpp/project/libs/nekoapi/bin/Linux/libneko.so
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/resources/app/node_modules/pty.js/build/Release/pty.node
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/resources/app/node_modules/gc-signals/build/Release/gcsignals.node
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/resources/app/node_modules/gc-signals/build/Release/obj.target/gcsignals.node
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/resources/app/node_modules/oniguruma/build/Release/onig_scanner.node
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/resources/app/node_modules/oniguruma/build/Release/obj.target/onig_scanner.node
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib:${xorg.libX11}/lib" $out/resources/app/node_modules/native-keymap/build/Release/keymapping.node
      patchelf --set-rpath ".:${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib:${xorg.libX11}/lib" $out/resources/app/node_modules/native-keymap/build/Release/obj.target/keymapping.node

      # Rewrite VSCODE_PATH inside bin/kodestudio to $out
      substituteInPlace $out/bin/kodestudio --replace "/usr/share/kodestudio" $out

      # Patch library calls that expects nix store files to be mode 644:
      #   A stat is made on srcFile (in the nix store), and its mode used
      #   for destFile, but it expects the mode to be read write, whereas
      #   all regular files in the nix store are made read only.
      #   (33188 is 100644 octal, the required mode)
      substituteInPlace $out/resources/app/extensions/kha/Kha/Tools/khamake/node_modules/fs-extra/lib/copy-sync/copy-file-sync.js --replace "stat.mode" "33188"
      substituteInPlace $out/resources/app/extensions/kha/Kha/Kore/Tools/koremake/node_modules/fs-extra/lib/copy-sync/copy-file-sync.js --replace "stat.mode" "33188"

      # Wrap preload libXss
      wrapProgram $out/bin/kodestudio \
          --prefix LD_PRELOAD : ${stdenv.lib.makeLibraryPath [ libXScrnSaver ]}/libXss.so.1
    '';

    meta = with stdenv.lib; {
      description = ''
        An IDE for Kha based on Visual Studio Code
      '';
      longDescription = ''
        Kode Studio is an IDE for Kha based on Visual Studio Code.

        Kha and Kore are multimedia frameworks for Haxe and C++ respectively
        (with JavaScript coming soon). Using Kha or Kore you can access all
        hardware at the lowest possible level in a completely portable way.
      '';
      homepage = http://kode.tech/;
      downloadPage = https://github.com/Kode/KodeStudio/releases;
      license = licenses.mit;
      maintainers = [ maintainers.patternspandemic ];
      platforms = [ "x86_64-linux" "i686-cygwin" ];
    };
  }
