{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  wrapGAppsHook3,
  cairo,
  copyDesktopItems,
  dbus,
  fontconfig,
  freetype,
  glib,
  gtk3,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXrandr,
  libXrender,
  libxkbcommon,
  libgit2,
  libglvnd,
  libuuid,
  libxcb,
  makeDesktopItem,
  harfbuzz,
  libsoup_3,
  webkitgtk_4_1,
  zenity,
}:
let
  gkIcon = fetchurl {
    url = "https://gist.githubusercontent.com/qbit/cb52e6cd193c410e0b0aee8a216f6574/raw/2b042bde1dc4cbd30457f14c9d18c889444bf3d0/glamoroustoolkit.svg";
    sha256 = "sha256-Trfo8P01anLq9yTFzwqIfsyidLGyuZDg48YQPrGBkgs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "glamoroustoolkit";
  version = "1.1.32";

  src = fetchzip {
    url = "https://github.com/feenkcom/gtoolkit-vm/releases/download/v${finalAttrs.version}/GlamorousToolkit-x86_64-unknown-linux-gnu.zip";
    stripRoot = false;
    hash = "sha256-uZrq4RM50NcQPHFFfqIRBJ/rq/I09D8WxKz3/xqpOEI=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    copyDesktopItems
  ];

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  desktopItems = with finalAttrs; [
    (makeDesktopItem {
      name = pname;
      desktopName = "GlamorousToolkit";
      exec = "GlamorousToolkit";
      icon = "GlamorousToolkit";
    })
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/lib $out/share/icons/hicolor/scalable/apps

    cp ${gkIcon} $out/share/icons/hicolor/scalable/apps/GlamorousToolkit.svg
    cp -r $src/bin $src/lib $out/
    cp ${./GlamorousToolkit-GetImage} $out/bin/GlamorousToolkit-GetImage

    runHook postInstall
  '';

  preFixup =
    let
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
        libxkbcommon
        libglvnd
        libuuid
        libxcb
        harfbuzz # libWebView.so
        libsoup_3 # libWebView.so
        webkitgtk_4_1 # libWebView.so
        (lib.getLib stdenv.cc.cc)
      ];
      binPath = lib.makeBinPath [
        zenity # File selection dialog
      ];
    in
    ''
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
        $out/lib/libWinit30.so \
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
