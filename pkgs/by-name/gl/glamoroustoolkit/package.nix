{ lib
, stdenv
, fetchzip
, fetchurl
, patchelf
, wrapGAppsHook3
, cairo
, dbus
, fontconfig
, freetype
, glib
, gtk3
, libX11
, libXcursor
, libXext
, libXi
, libXrandr
, libXrender
, libgit2
, libglvnd
, libuuid
, libxcb
, harfbuzz
, libsoup_3
, webkitgtk_4_1
, zenity
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glamoroustoolkit";
  version = "1.1.7";

  src = fetchzip {
    url = "https://github.com/feenkcom/gtoolkit-vm/releases/download/v${finalAttrs.version}/GlamorousToolkit-x86_64-unknown-linux-gnu.zip";
    stripRoot = false;
    hash = "sha256-ji77uc7UnfiDVCERWwDpMnBiSJjDrr84yYrobLhKWlE=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/lib
    cp -r $src/bin $src/lib $out/
    cp ${./GlamorousToolkit-GetImage} $out/bin/GlamorousToolkit-GetImage

    runHook postInstall
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      cairo
      dbus
      fontconfig
      freetype
      glib
      gtk3
      libX11
      libXcursor
      libXext
      libXi
      libXrandr
      libXrender
      libglvnd
      libuuid
      libxcb
      harfbuzz        # libWebView.so
      libsoup_3       # libWebView.so
      webkitgtk_4_1   # libWebView.so
      (lib.getLib stdenv.cc.cc)
    ];
    binPath = lib.makeBinPath [
      zenity          # File selection dialog
    ];
  in ''
    chmod +x $out/lib/*.so
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}:$out/lib" \
      $out/bin/GlamorousToolkit $out/bin/GlamorousToolkit-cli
    patchelf --shrink-rpath \
      $out/bin/GlamorousToolkit $out/bin/GlamorousToolkit-cli
    patchelf \
      --set-rpath "${libPath}:$out/lib" \
      $out/lib/*.so
    patchelf --shrink-rpath $out/lib/*.so
    #
    # shrink-rpath gets it wrong for the following libraries,
    # restore the full rpath.
    #
    patchelf \
      --set-rpath "${libPath}:$out/lib" \
      $out/lib/libPharoVMCore.so \
      $out/lib/libWinit.so \
      $out/lib/libPixels.so
    patchelf --set-rpath $out/lib $out/lib/libssl.so

    ln -s $out/lib/libcrypto.so $out/lib/libcrypto.so.1.1
    ln -s $out/lib/libcairo.so $out/lib/libcairo.so.2
    rm $out/lib/libgit2.so
    ln -s "${libgit2}/lib/libgit2.so" $out/lib/libgit2.so.1.1

    gappsWrapperArgs+=(
      --prefix PATH : ${binPath}
    )
  '';

  meta = {
    homepage = "https://gtoolkit.com";
    description = "GlamorousToolkit Development Environment";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.akgrant43 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
