{ stdenv, fetchurl, libX11, libXext, libXcursor, libXrandr, libjack2, alsaLib
, mpg123, releasePath ? null }:

with stdenv.lib;

# To use the full release version:
# 1) Sign into https://backstage.renoise.com and download the release version to some stable location.
# 2) Override the releasePath attribute to point to the location of the newly downloaded bundle.
# Note: Renoise creates an individual build for each license which screws somewhat with the
# use of functions like requireFile as the hash will be different for every user.
let
  urlVersion = replaceStrings [ "." ] [ "_" ];
in

stdenv.mkDerivation rec {
  pname = "renoise";
  version = "3.2.1";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
        if releasePath == null then
		    fetchurl {
		      urls = [
		          "https://files.renoise.com/demo/Renoise_${urlVersion version}_Demo_Linux.tar.gz"
		          "https://web.archive.org/web/https://files.renoise.com/demo/Renoise_${urlVersion version}_Demo_Linux.tar.gz"
		      ];
		      sha256 = "0dhcidgnjzd4abw0xw1waj9mazp03nbvjcr2xx09l8gnfrkvny46";
		    }
        else
        	releasePath
    else throw "Platform is not supported by Renoise";

  buildInputs = [ alsaLib libjack2 libX11 libXcursor libXext libXrandr ];

  installPhase = ''
    cp -r Resources $out

    mkdir -p $out/lib/

    mv $out/AudioPluginServer* $out/lib/

    cp renoise $out/renoise

    for path in ${toString buildInputs}; do
      ln -s $path/lib/*.so* $out/lib/
    done

    ln -s ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 $out/lib/

    mkdir $out/bin
    ln -s $out/renoise $out/bin/renoise
  '';

  postFixup = ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath ${mpg123}/lib:$out/lib \
      $out/renoise
  '';

  meta = {
    description = "Modern tracker-based DAW";
    homepage = https://www.renoise.com/;
    license = licenses.unfree;
    maintainers = [];
    platforms = [ "x86_64-linux" ];
  };
}
