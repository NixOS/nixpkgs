{ lib, stdenv, fetchurl, libX11, libXext, libXcursor, libXrandr, libjack2, alsa-lib
, mpg123, releasePath ? null }:

# To use the full release version:
# 1) Sign into https://backstage.renoise.com and download the release version to some stable location.
# 2) Override the releasePath attribute to point to the location of the newly downloaded bundle.
# Note: Renoise creates an individual build for each license which screws somewhat with the
# use of functions like requireFile as the hash will be different for every user.
let
  urlVersion = lib.replaceStrings [ "." ] [ "_" ];
in

stdenv.mkDerivation rec {
  pname = "renoise";
  version = "3.3.2";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
        if releasePath == null then
        fetchurl {
          urls = [
              "https://files.renoise.com/demo/Renoise_${urlVersion version}_Demo_Linux.tar.gz"
              "https://web.archive.org/web/https://files.renoise.com/demo/Renoise_${urlVersion version}_Demo_Linux.tar.gz"
          ];
          sha256 = "0d9pnrvs93d4bwbfqxwyr3lg3k6gnzmp81m95gglzwdzczxkw38k";
        }
        else
          releasePath
    else throw "Platform is not supported. Use installation native to your platform https://www.renoise.com/";

  buildInputs = [ alsa-lib libjack2 libX11 libXcursor libXext libXrandr ];

  installPhase = ''
    cp -r Resources $out

    mkdir -p $out/lib/

    cp renoise $out/renoise

    for path in ${toString buildInputs}; do
      ln -s $path/lib/*.so* $out/lib/
    done

    ln -s ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 $out/lib/

    mkdir $out/bin
    ln -s $out/renoise $out/bin/renoise

    # Desktop item
    mkdir -p $out/share/applications
    cp -r Installer/renoise.desktop $out/share/applications/renoise.desktop

    # Desktop item icons
    mkdir -p $out/share/icons/hicolor/{48x48,64x64,128x128}/apps
    cp Installer/renoise-48.png $out/share/icons/hicolor/48x48/apps/renoise.png
    cp Installer/renoise-64.png $out/share/icons/hicolor/64x64/apps/renoise.png
    cp Installer/renoise-128.png $out/share/icons/hicolor/128x128/apps/renoise.png
  '';

  postFixup = ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath ${mpg123}/lib:$out/lib \
      $out/renoise

    for path in $out/AudioPluginServer*; do
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath $out/lib \
        $path
    done

    substituteInPlace $out/share/applications/renoise.desktop \
      --replace Exec=renoise Exec=$out/bin/renoise
  '';

  meta = {
    description = "Modern tracker-based DAW";
    homepage = "https://www.renoise.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [];
    platforms = [ "x86_64-linux" ];
  };
}
