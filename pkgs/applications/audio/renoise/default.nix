{ stdenv, fetchurl, libX11, libXext, libXcursor, libXrandr, libjack2, alsaLib, releasePath ? null }:

with stdenv.lib;

# To use the full release version:
# 1) Sign into https://backstage.renoise.com and download the appropriate (x86 or x86_64) version
#    for your machine to some stable location.
# 2) Override the releasePath attribute to point to the location of the newly downloaded bundle.
# Note: Renoise creates an individual build for each license which screws somewhat with the
# use of functions like requireFile as the hash will be different for every user.
let
  urlVersion = replaceStrings [ "." ] [ "_" ];
in

stdenv.mkDerivation rec {
  name = "renoise-${version}";
  version = "3.1.0";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
        if builtins.isNull releasePath then
        fetchurl {
          url = "https://files.renoise.com/demo/Renoise_${urlVersion version}_Demo_x86_64.tar.bz2";
          sha256 = "0pan68fr22xbj7a930y29527vpry3f07q3i9ya4fp6g7aawffsga";
        }
        else
        releasePath
    else if stdenv.hostPlatform.system == "i686-linux" then
        if builtins.isNull releasePath then
        fetchurl {
          url = "http://files.renoise.com/demo/Renoise_${urlVersion version}_Demo_x86.tar.bz2";
          sha256 = "1lccjj4k8hpqqxxham5v01v2rdwmx3c5kgy1p9lqvzqma88k4769";
        }
        else
        releasePath
    else throw "Platform is not supported by Renoise";

  buildInputs = [ libX11 libXext libXcursor libXrandr alsaLib libjack2 ];

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

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $out/lib $out/renoise
  '';

  meta = {
    description = "Modern tracker-based DAW";
    homepage = http://www.renoise.com/;
    license = licenses.unfree;
    maintainers = [];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
